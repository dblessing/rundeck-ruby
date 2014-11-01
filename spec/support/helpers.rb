module Helpers
  # Remove this after refactored to vcr
  def load_fixture(name)
    File.new(File.dirname(__FILE__) + "/../fixtures/#{name}.xml")
  end

  # GET
  def stub_get(path, fixture, accept = 'xml')
    stub_request(:get, "#{Rundeck.endpoint}#{path}")
      .with(headers: { 'Accept' => "application/#{accept}",
                       'X-Rundeck-Auth-Token' => Rundeck.api_token })
      .to_return(body: load_fixture(fixture))
  end

  def a_get(path, accept = 'xml')
    a_request(:get, "#{Rundeck.endpoint}#{path}")
      .with(headers: { 'Accept' => "application/#{accept}",
                       'X-Rundeck-Auth-Token' => Rundeck.api_token })
  end

  # POST
  def stub_post(path, fixture, status_code = 200, accept = 'xml')
    stub_request(:post, "#{Rundeck.endpoint}#{path}")
      .with(headers: { 'Accept' => "application/#{accept}",
                       'X-Rundeck-Auth-Token' => Rundeck.api_token })
      .to_return(body: load_fixture(fixture), status: status_code)
  end

  def a_post(path, accept = 'xml')
    a_request(:post, "#{Rundeck.endpoint}#{path}")
      .with(headers: { 'Accept' => "application/#{accept}",
                       'X-Rundeck-Auth-Token' => Rundeck.api_token })
  end

  # PUT
  def stub_put(path, fixture, accept = 'xml')
    stub_request(:put, "#{Rundeck.endpoint}#{path}")
      .with(headers: { 'Accept' => "application/#{accept}",
                       'X-Rundeck-Auth-Token' => Rundeck.api_token })
      .to_return(body: load_fixture(fixture))
  end

  def a_put(path, accept = 'xml')
    a_request(:put, "#{Rundeck.endpoint}#{path}")
      .with(headers: { 'Accept' => "application/#{accept}",
                       'X-Rundeck-Auth-Token' => Rundeck.api_token })
  end

  # DELETE
  def stub_delete(path, fixture, accept = 'xml')
    stub_request(:delete, "#{Rundeck.endpoint}#{path}")
      .with(headers: { 'Accept' => "application/#{accept}",
                       'X-Rundeck-Auth-Token' => Rundeck.api_token })
      .to_return(body: load_fixture(fixture))
  end

  def a_delete(path, accept = 'xml')
    a_request(:delete, "#{Rundeck.endpoint}#{path}")
      .with(headers: { 'Accept' => "application/#{accept}",
                       'X-Rundeck-Auth-Token' => Rundeck.api_token })
  end

  def job_yaml
    <<-EOS
- project: anvils
  loglevel: INFO
  sequence:
    keepgoing: true
    strategy: node-first
    commands:
    - exec: echo 'hello world'
  description: Check the status of anvils
  name: My YAML Job
  group: anvils
    EOS
  end

  def job_xml
    <<-EOS
<joblist>
  <job>
    <loglevel>INFO</loglevel>
    <sequence keepgoing='true' strategy='node-first'>
      <command>
        <exec>echo 'hello world'</exec>
      </command>
    </sequence>
    <description>Check the status of anvils</description>
    <name>My XML Job</name>
    <context>
      <project>anvils</project>
    </context>
    <group>anvils</group>
  </job>
</joblist>
    EOS
  end

  def private_key
    <<-EOS
-----BEGIN RSA PRIVATE KEY-----
MIIEpQIBAAKCAQEAt6G5YJC4x4UiRQB08dsLavDM92HVnQINs4fiAUgZsPICTAhb
Agn7XRXU+P8fX1aReRi2p4LHSItdl5hjT2WkNCH1Niw9fpltiNhnlOlrpoBt/eWM
dd2rJtC00jQ4pDv+1edw9pc+Re7fDQYD4HSmhm/expQLAgu+LSFCdL7Fj05OAN7D
0RxwFfQ3wrZe5qGt4tr5objA2wXwGEnMpFqFGGI9+uqSKnuw1aUgVf7iRvec1fJT
/hmFSastozEnBJmBB/mQoFvjOqz+oSiXmXiwvoHfw9B8AdbxKpmi4+AfSTmJqYT1
j4FPO6JJf78Qx0Uh7eWQcC7uxhLa5XpHr6C/qQIDAQABAoIBAAR18ULfQR3XphV3
BWA6qfRXFSONRNsjiaGq01qknbsmpdei/FL4WxrPxPSnfeOa/r2qVAWNr7mbaRKd
qQvstChwCrzeJkBFCdwhJaMAaJUK2aEpSlgyok23FC1nB1k1++LGVIAo/GJGgzSV
yNJTAxiQ7yBzyDCsiFogTLT5TWNFwSPOSWTbUQIMW0BGVnVlecB/VIJN1zrBZSAe
T/MZenbjybkuTuXWod09YS9Yvx17eG/21I11AwBcmc5MlAn9nkZbydQs6kbLd9hx
KT7d9c42ocrTVrmMBcF7S5W8BdMp90snNc7sG99sQJ4W5BL8a46i4kVf6yURh5dy
orDDdAECgYEA4wh/jPEcfW/gP1nE9ydLYvgz7tC6+sWR1I7519W15NFABzoW6cw6
wjyWhR61EMir9ylTEc5FPwGgodVFb9ctIE+MMH1JL5XGCvAf5J62Hy+O0QnN2bEp
rdSf02Huw+6+6S7VXU50SjazeIU2qJ77ti05ukEe8unG9QNlr+Mk7pkCgYEAzw+e
sydIVNdi4IJqiJgcikcaBB8V+CimTC1sPzF3/iDSW0LAWTqhdlZIv8My6O8V85go
LjNv2+4ODo3b5wFrDHZ8yFgEzMa2SUDz2EgS3MlpaIrfpqzbr8womAaCJr2RYzGZ
kh9LmvbDEjXJqsABnW6XG5wOnSYoajp8cztqU5ECgYEA3DHi3AUCN9rpKShc88WF
xXCrleWWZCB5ByrAwYiCSXJ14kyB6rJtDvSKnIQi4ytuNmM7MVrZKHngnPVnykht
eRgOBP2OnPtrwDITDL6uLuMGZlJW99tvbCx78x3Z4OjO+wS0ZjHwcgZJ3Qt+7t57
jb6hbbc5WCpLEFoCJyxsJokCgYEAyFmv0F/BMD6ccOogFP1CGFZGCRjfFBiZGHqX
E+pU1bOCd0V2gqAlnTBOAibo+tRkZCilMFca9C46scB3t+T6ZLu9b8kjE9VuiiDs
ESlj/vhwIvTFBSybAVZFLRyXEM86f0V9+BKKAG6mP9eFw883gNKCKffteAd08ZyX
0JP8BNECgYEAprEkF/YNMl+Se5V2Rz8jrpstlbwrF3M3QHa6UflmOcnQcLHXKU8B
PZdVDER5VyhZdTpTb5wHY3ZDkig3YV0xxdS6uhdG34Gj0M2G2DFMGAQeWEgfJDas
c2kwvmY7JQlTx0zrcpGcnFiW2kNyHToI7QiE/Q02BqIdHjr6lrSpu18=
-----END RSA PRIVATE KEY-----
    EOS
  end

  def public_key
    <<-EOS
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3oblgkLjHhSJFAHTx2wtq8Mz3YdWdAg2zh+IBSBmw8gJMCFsCCftdFdT4/x9fVpF5GLangsdIi12XmGNPZaQ0IfU2LD1+mW2I2GeU6WumgG395Yx13asm0LTSNDikO/7V53D2lz5F7t8NBgPgdKaGb97GlAsCC74tIUJ0vsWPTk4A3sPRHHAV9DfCtl7moa3i2vmhuMDbBfAYScykWoUYYj366pIqe7DVpSBV/uJG95zV8lP+GYVJqy2jMScEmYEH+ZCgW+M6rP6hKJeZeLC+gd/D0HwB1vEqmaLj4B9JOYmphPWPgU87okl/vxDHRSHt5ZBwLu7GEtrlekevoL+p test@localhost
    EOS
  end
end

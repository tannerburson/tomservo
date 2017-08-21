class PageAnEngineerCommand
  def initialize(opts= {})
    @opts = opts
  end

  def self.call(opts,payload)
    new(opts).call(payload)
  end

  def call(payload)
    reason = JSON.generate(payload[:text])
    return {
          "text": "Cool, you want to find an engineer about #{reason}.",
          "attachments": [
              {
                  "text": "Before I find someone, how serious is this?",
                  "fallback": "Not sure...",
                  "callback_id": "page_severity",
                  "color": "#f00",
                  "attachment_type": "default",
                  "actions": [
                      {
                          "name": "list",
                          "text": "Severity",
                          "type": "select",
                          "options": [
                            {
                              "text": "Noone can checkout/we're down",
                              "value": "{\"text\": #{reason},\"value\": \"outage\"}"
                            },
                            {
                              "text": "Some users are seeing errors",
                              "value": "{\"text\": #{reason},\"value\": \"mostly_busted\"}"
                            },
                            {
                              "text": "No big deal,I have a question",
                              "value": "{\"text\": #{reason},\"value\": \"not_busted\"}"
                            }
                          ]
                      }
                  ]
              }
          ]
      }
  end
end

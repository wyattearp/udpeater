json.array!(@messages) do |message|
  json.extract! message, :id, :dst_ip, :dst_port, :async, :msg_raw, :message_data, :message_response
  json.url message_url(message, format: :json)
end

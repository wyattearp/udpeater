class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.all
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(message_params)

    udp_sock = UDPSocket.new()
    address = message_params[:dst_ip]
    @message.dst_ip = IPAddr.new(address, Socket::AF_INET).to_i()

    udp_sock.connect(address, @message.dst_port.to_i())
    if @message.msg_raw
      # TOOD: support correctly, this is WRONG
      udp_sock.send(@message.message_data, 0)
    else
      udp_sock.send(@message.message_data, 0)
    end

    # we're only doing sync stuff and expecting a response for the moment
    unless @message.async
      begin
        result = udp_sock.recvfrom(65535)
        @message.message_response = result[0]
      rescue Errno::ECONNREFUSED
        # TODO: this is terrible
        @message.message_response = ""
      end
    end

    respond_to do |format|
      if @message.save
        format.html { redirect_to @message, notice: 'Message was successfully created.' }
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render :new }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
    # TODO: async call handling here on a new thread
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:dst_ip, :dst_port, :async, :msg_raw, :message_data, :message_response)
    end
end

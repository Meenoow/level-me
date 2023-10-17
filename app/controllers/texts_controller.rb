class TextsController < ApplicationController
  require 'httparty'
  require 'dotenv'

  def index
    # Empty action for displaying the form
  end

  def create
    input_text = params[:input_text]
    grade_level = params[:grade_level]
    api_key = ENV['OPENAI_API_KEY']

    response = HTTParty.post(
      'https://api.openai.com/v1/engines/davinci/completions',
      headers: {
        'Authorization' => "Bearer #{api_key}",
        'Content-Type' => 'application/json'
      },
      body: {
        prompt: "Translate the following text to #{grade_level} grade level: #{input_text}",
        max_tokens: 900
      }.to_json
    )

      if response.code != 200
        # Handle the error, e.g., log or display an error message
        puts "Error response code: #{response.code}"
      end

      parsed_response = JSON.parse(response.body)
      @output_text = parsed_response.dig('choices', 0, 'text')
      puts "Parsed Response: #{parsed_response}"


    render :index
  end
end

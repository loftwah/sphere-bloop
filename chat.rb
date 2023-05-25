require "openai"
require 'dotenv'

# Load environment variables
Dotenv.load

# Configure the OpenAI with your API key from .env file
OpenAI.configure do |config|
  config.access_token = ENV.fetch("OPENAI_ACCESS_TOKEN")
end

# Create a new client
client = OpenAI::Client.new

# Let's assume you have the user's message in variable user_message
user_message = ARGV[0]

# Generate a response using ChatGPT
response = client.chat(
    parameters: {
        model: "gpt-3.5-turbo", # Use the appropriate model
        messages: [{ role: "user", content: user_message }], # Use the user's message
        temperature: 0.7,
    })

# Extract the content of the response
bot_response = response.dig("choices", 0, "message", "content")

puts "First Response: #{bot_response}"

# Feed the first response back into GPT with TLDR prompt
response = client.chat(
    parameters: {
        model: "gpt-3.5-turbo", 
        messages: [{ role: "user", content: "TLDR: #{bot_response}" }],
        temperature: 0.7,
    })

# Extract the content of the TLDR response
tldr_response = response.dig("choices", 0, "message", "content")

puts "TLDR Response: #{tldr_response}"

# Feed the TLDR response back into GPT with prompt to check for errors and apply Australian English
response = client.chat(
    parameters: {
        model: "gpt-3.5-turbo", 
        messages: [{ role: "user", content: "Proofread this and convert it into Australian English: #{tldr_response}" }],
        temperature: 0.7,
    })

# Extract the final response
final_response = response.dig("choices", 0, "message", "content")

puts "Final Response: #{final_response}"

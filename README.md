# Aipipe

Aipipe is a command-line tool designed to integrate Large Language Models (LLMs) into shell scripts. It provides a seamless interface to Ollama, supporting pipe operations and making AI capabilities readily available in your command-line workflow.

## Features

- Pipe input/output support
- Automatic Ollama service management
- Custom model selection
- System prompt support
- Configurable API endpoints

## Prerequisites

Ensure you have the following installed:
- [Crystal](https://crystal-lang.org/install/)
- [Ollama](https://ollama.ai/)

## Installation

Clone and build the project:
```
bash
git clone https://github.com/yourusername/aipipe.git
cd aipipe
shards install
crystal build src/aipipe.cr -o bin/aipipe --release
```

## Usage

### Basic Commands
```bash
# Direct question
aipipe ask "What is 1+1?"
# Using pipes
echo "Explain this code" | aipipe ask
# Specify model
aipipe ask -m codellama "Analyze this code"
# With system prompt
aipipe ask -s "You are a Shell expert" "Optimize this script"
```
### Script Integration
```bash
# Log analysis
cat error.log | aipipe ask "Analyze these error messages"
# Code review
git diff | aipipe ask -m codellama "Review these code changes"
# System diagnostics
top -b -n 1 | aipipe ask "Analyze system performance"

```

## Configuration

Configure through environment variables:
```bash
# Ollama API endpoint
export OLLAMA_API_BASE="http://localhost:11434"
# Default model
export OLLAMA_MODEL="qwen2.5"
# Ollama port
export OLLAMA_PORT=11434
# Log level
export AIPIPE_LOG_LEVEL=DEBUG
```
## Development
```bash
# Install dependencies
shards install
# Run tests
crystal spec
# Development mode
./scripts/dev.sh ask "test question"
```

## Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

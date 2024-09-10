#!/bin/bash

# Input JSON file
input_file=$1
# Output SARIF file
output_file=$2

# Initialize the SARIF structure
echo '{
  "version": "2.1.0",
  "$schema": "https://json.schemastore.org/sarif-2.1.0.json",
  "runs": [
    {
      "tool": {
        "driver": {
          "name": "Aquilax",
          "informationUri": "https://app.aquilax.ai",
          "rules": []
        }
      },
      "results": []
    }
  ]
}' > "$output_file"

# Extract findings and append to SARIF file
jq -r '
  .scan.results[] |
  select(.findings != null) |
  .findings[] |
  {
    ruleId: .id,
    message: { text: .message },
    locations: [
      {
        physicalLocation: {
          artifactLocation: { uri: .path },
          region: {
            startLine: .line_start,
            endLine: .line_end
          }
        }
      }
    ],
    level: (.severity | ascii_downcase)
  }' "$input_file" | jq -s '
    . as $findings |
    {
      $schema: "https://json.schemastore.org/sarif-2.1.0.json",
      version: "2.1.0",
      runs: [
        {
          tool: {
            driver: {
              name: "Aquilax",
              informationUri: "https://app.aquilax.ai",
              rules: []
            }
          },
          results: $findings
        }
      ]
    }' > "$output_file"

# Validate SARIF file
if jq . "$output_file" > /dev/null 2>&1; then
  echo "SARIF conversion completed. Output file: $output_file"
else
  echo "Invalid SARIF JSON format. Exiting."
  exit 1
fi

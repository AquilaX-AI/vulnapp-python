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
            startLine: (if .line_start < 1 then 1 else .line_start end),
            endLine: (if .line_end < 1 then 1 else .line_end end)
          }
        }
      }
    ],
    level: (
      if .severity == "HIGH" then "error"
      elif .severity == "MEDIUM" then "warning"
      elif .severity == "LOW" or .severity == "Unknown" then "note"
      else "none"
      end
    ),
    properties: {
      vulnerability: .vuln,
      confidence: .confidence,
      impact: .impact,
      likelihood: .likelihood,
      recommendation: .recommendation,
      owasp: .owasp,
      cwe: .cwe,
      references: .references
    }
  }' "$input_file" | jq -s '
    {
      "$schema": "https://json.schemastore.org/sarif-2.1.0.json",
      "version": "2.1.0",
      "runs": [
        {
          "tool": {
            "driver": {
              "name": "Aquilax",
              "informationUri": "https://app.aquilax.ai",
              "rules": []
            }
          },
          "results": .
        }
      ]
    }' > "$output_file"

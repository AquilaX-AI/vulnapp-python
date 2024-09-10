#!/bin/bash

# Script for converting Aquilax scan results to SARIF format for GitHub code scanning.

# Check if the correct number of arguments is provided
if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <input_json_file> <output_sarif_file>"
  exit 1
fi

# Input and output files
input_file=$1
output_file=$2

# Validate that the input file exists and is readable
if [[ ! -r "$input_file" ]]; then
  echo "Error: Input file '$input_file' not found or is not readable."
  exit 1
fi

# Validate that jq is installed
if ! command -v jq &> /dev/null; then
  echo "Error: jq is not installed. Please install jq to use this script."
  exit 1
fi

# Initialize the SARIF structure
cat <<EOF > "$output_file"
{
  "version": "2.1.0",
  "\$schema": "https://json.schemastore.org/sarif-2.1.0.json",
  "runs": [
    {
      "tool": {
        "driver": {
          "name": "Aquilax",
          "version": "1.0.0",
          "informationUri": "https://app.aquilax.ai",
          "rules": []
        }
      },
      "results": []
    }
  ]
}
EOF

# Extract findings from input JSON and append them to SARIF output
findings=$(jq -r '
  .scan.results[] |
  select(.findings != null) |
  .findings[] |
  {
    ruleId: .id,
    level: (
      if .severity == "HIGH" then "error"
      elif .severity == "MEDIUM" then "warning"
      elif .severity == "LOW" or .severity == "Unknown" then "note"
      else "none"
      end
    ),
    message: { text: .message },
    locations: [
      {
        physicalLocation: {
          artifactLocation: { uri: .path },
          region: {
            startLine: (if .line_start < 1 then 1 else .line_start end),
            endLine: (if .line_end < 1 then 1 else .line_end end),
            startColumn: 1,  # Assuming start column is always 1
            endColumn: 1      # Assuming end column is 1 when not specified
          }
        }
      }
    ],
    properties: {
      shortDescription: {
        text: .vuln
      },
      fullDescription: {
        text: .message
      },
      helpUri: "https://docs.aquilax.ai/rules/\(.id)",
      confidence: .confidence,
      impact: .impact,
      likelihood: .likelihood,
      recommendation: .recommendation,
      owasp: .owasp,
      cwe: .cwe,
      references: .references
    }
  }' "$input_file")

# Check if findings are empty
if [[ -z "$findings" ]]; then
  echo "Error: No findings found in the input file."
  exit 1
fi

# Append findings to SARIF results
jq --argjson findings "$findings" '
  .runs[0].results = $findings
' "$output_file" > tmp_output && mv tmp_output "$output_file"

echo "SARIF file '$output_file' generated successfully."

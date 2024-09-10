input_file=$1
output_file=$2

cat <<EOF > "$output_file"
{
  "version": "2.1.0",
  "\$schema": "https://json.schemastore.org/sarif-2.1.0.json",
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
}
EOF

jq -r '.scan.results[] | .findings[] | 
"{
  \"ruleId\": \"\(.id)\",
  \"message\": { \"text\": \"\(.message)\" },
  \"locations\": [{
    \"physicalLocation\": {
      \"artifactLocation\": { \"uri\": \"\(.path)\" },
      \"region\": {
        \"startLine\": \(.line_start),
        \"endLine\": \(.line_end)
      }
    }
  }],
  \"level\": \"\(.severity | ascii_downcase)\"
}"' "$input_file" >> "$output_file"

echo "SARIF conversion completed. Output file: $output_file"

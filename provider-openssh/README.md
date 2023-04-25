> ok it was basically... build cmd/pulumi-resource-opensshcertificate and copy it to ~/.pulumi/plugins/resource-opensshcertificate-VERSION/resource-opensshcertificate or something... run cmd/pulumi-gen-command to generate schema file, then pulumi package gen-sdk --language go on the schema file

at the stage of "to generate schema file":
./pulumi-gen-command cmd/pulumi-resource-opensshcertificate/schema.json
pulumi package gen-sdk --language go cmd/pulumi-resource-opensshcertificate/schema.json

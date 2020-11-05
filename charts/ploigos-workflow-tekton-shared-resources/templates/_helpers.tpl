{{/*
Expand the name of the chart.
*/}}
{{- define "ploigos-workflow-tekton-shared-resources.name" -}}
{{- .Values.global.nameOverride | default .Values.nameOverride | default .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ploigos-workflow-tekton-shared-resources.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ploigos-workflow-tekton-shared-resources.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Expand the name of the application service this pipeline is for.
*/}}
{{- define "ploigos-workflow-tekton.pipelineName" -}}
{{- printf "%s-%s" (required "Global Value is required: applicationName" $.Values.global.applicationName) (required "Global Value is required: serviceName" $.Values.global.serviceName) | trunc 50 | trimSuffix "-" }}
{{- end }}

{{- define "ploigos-workflow-tekton.triggerTemplateName" -}}
{{- printf "%s" (include "ploigos-workflow.resourcesName" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "ploigos-workflow-tekton.eventListenerName" -}}
{{- printf "%s" (include "ploigos-workflow.resourcesName" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "ploigos-workflow-tekton.eventListenerIngressName" -}}
{{- printf "el-%s" (include "ploigos-workflow-tekton.eventListenerName" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "ploigos-workflow-tekton.eventListenerServiceAccountName" -}}
{{- printf "el-%s" (include "ploigos-workflow-tekton.eventListenerName" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "ploigos-workflow.cronJobCleanupName" -}}
{{- printf "cleanup-%s" (include "ploigos-workflow.resourcesName" .) | trunc 52 | trimSuffix "-" }}
{{- end }}

{{/*
The Service for the EventListner is created by the Pipeline operator automatically.
The name of the created Service is created by adding 'el-' to the EventListner name.

NOTE:   it would be slicker to dynamically querier for the service after the EventListener is
        created, but you can't do that in helm templates, so this will have to do.
*/}}
{{- define "ploigos-workflow-tekton.eventListenerServiceName" -}}
{{- printf "el-%s" (include "ploigos-workflow-tekton.eventListenerName" .) }}
{{- end }}

{{/*
Gets the prefix to use for Secrets to be associated with the workflow ServiceAccount.

NOTE:
  Ideally this would have taken in a parameter of the suffix to add, but I couldn't figure
  out how to conqure go-template scoping.
*/}}
{{- define "ploigos-workflow.workflowServiceAccountSecretNamePrefix" -}}
{{- printf "git-ssh-keys-%s" (include "ploigos-workflow.resourcesName" $) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Creates a yaml array of secrets to add to the workflow ServiceAccount.

For Tekton that is the list of git SSH Keys Secrets.
*/}}
{{- define "ploigos-workflow.workflowServiceAccountSecrets" -}}
{{- if $.Values.global.tektonGitSSHKeys }}

{{- range $sshKeyName, $sshKeyValues := $.Values.global.tektonGitSSHKeys }}
- name: {{ printf "%s-%s" (include "ploigos-workflow.workflowServiceAccountSecretNamePrefix" $) ($sshKeyName) | trunc -63 | trimPrefix "-" }}
{{- end }}
{{- else -}}
 []
{{- end }}
{{- end }}

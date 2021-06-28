{{/*
Expand the name of the chart.
*/}}
{{- define "ploigos-workflow-tekton-pipeline-typical.name" -}}
{{- .Values.global.nameOverride | default .Values.nameOverride | default .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ploigos-workflow-tekton-pipeline-typical.fullname" -}}
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
{{- define "ploigos-workflow-tekton-pipeline-typical.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ploigos-workflow.labels" -}}
helm.sh/chart: {{ include "ploigos-workflow-tekton-pipeline-typical.chart" . }}
{{ include "ploigos-workflow.selectorLabels" . }}
{{- if .Chart.AppVersion }}
ploigos/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: ploigos-workflow
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ploigos-workflow.selectorLabels" -}}
app.kubernetes.io/name: {{ (required "Global Value is required: serviceName" .Values.global.serviceName) }}
app.kubernetes.io/part-of: {{ (required "Global Value is required: applicationName" .Values.global.applicationName) }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

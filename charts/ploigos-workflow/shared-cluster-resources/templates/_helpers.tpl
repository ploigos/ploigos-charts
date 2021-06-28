{{/*
Expand the name of the chart.
*/}}
{{- define "ploigos-workflow-shared-cluster-resources.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ploigos-workflow-shared-cluster-resources.fullname" -}}
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
{{- define "ploigos-workflow-shared-cluster-resources.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ploigos-workflow-shared-cluster-resources.labels" -}}
helm.sh/chart: {{ include "ploigos-workflow-shared-cluster-resources.chart" . }}
{{ include "ploigos-workflow-shared-cluster-resources.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ploigos-workflow-shared-cluster-resources.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ploigos-workflow-shared-cluster-resources.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "ploigos-workflow-shared-cluster-resources.rbacName" -}}
{{- default "ploigos-workflow-runner" .Values.rbacNameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

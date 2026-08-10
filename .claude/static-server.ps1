param([int]$Port = 8000, [string]$Root = ".")

$Root = (Resolve-Path $Root).Path
$default = "buscador_bibliografico_ucab 1.2.html"

$mime = @{
  ".html" = "text/html; charset=utf-8"
  ".htm"  = "text/html; charset=utf-8"
  ".js"   = "text/javascript; charset=utf-8"
  ".css"  = "text/css; charset=utf-8"
  ".json" = "application/json; charset=utf-8"
  ".svg"  = "image/svg+xml"
  ".png"  = "image/png"
  ".jpg"  = "image/jpeg"
  ".xlsx" = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
}

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$Port/")
$listener.Start()
Write-Host "Serving '$Root' at http://localhost:$Port/"

try {
  while ($listener.IsListening) {
    $ctx = $listener.GetContext()
    try {
      $rel = [Uri]::UnescapeDataString($ctx.Request.Url.AbsolutePath.TrimStart('/'))
      if ([string]::IsNullOrEmpty($rel)) { $rel = $default }
      $path = Join-Path $Root $rel
      $isHead = $ctx.Request.HttpMethod -eq 'HEAD'

      if (Test-Path -LiteralPath $path -PathType Leaf) {
        $bytes = [System.IO.File]::ReadAllBytes($path)
        $ext = [System.IO.Path]::GetExtension($path).ToLower()
        if ($mime.ContainsKey($ext)) { $ctx.Response.ContentType = $mime[$ext] }
        if ($isHead) {
          $ctx.Response.ContentLength64 = $bytes.Length
          $ctx.Response.Close()
        } else {
          $ctx.Response.Close($bytes, $true)
        }
      } else {
        $ctx.Response.StatusCode = 404
        $msg = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found: $rel")
        if ($isHead) { $ctx.Response.Close() } else { $ctx.Response.Close($msg, $true) }
      }
    } catch {
      Write-Host "Request error: $($_.Exception.Message)"
      try { $ctx.Response.Abort() } catch {}
    }
  }
} finally {
  $listener.Stop()
}

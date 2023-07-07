# set-ExecutionPolicy RemoteSigned
param($image_path, $sel_jpg, $pipe_txt)
Add-Type -AssemblyName System.Windows.Forms;
if ($([System.Windows.Forms.Clipboard]::ContainsImage())) {
  $imageObj = [System.Drawing.Bitmap][System.Windows.Forms.Clipboard]::GetDataObject().getimage();
  if ($sel_jpg -eq "sel_jpg") {
    $imageObj.Save($image_path, [System.Drawing.Imaging.ImageFormat]::Jpeg);
  } else {
    $imageObj.Save($image_path, [System.Drawing.Imaging.ImageFormat]::Png);
  }
  "success" | Out-File -FilePath $pipe_txt -NoNewLine -Encoding UTF8
} else {
  "fail" | Out-File -FilePath $pipe_txt -NoNewLine -Encoding UTF8
  Write-Host "No Image in Clipboard!"
}

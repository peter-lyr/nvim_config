# set-ExecutionPolicy RemoteSigned
param($image_path, $png)
Add-Type -AssemblyName System.Windows.Forms;
if ($([System.Windows.Forms.Clipboard]::ContainsImage())) {
  $imageObj = [System.Drawing.Bitmap][System.Windows.Forms.Clipboard]::GetDataObject().getimage();
  if ($png -eq "png") {
    $imageObj.Save($image_path, [System.Drawing.Imaging.ImageFormat]::Jpeg);
  } else {
    $imageObj.Save($image_path, [System.Drawing.Imaging.ImageFormat]::Png);
  }
}

# set-ExecutionPolicy RemoteSigned
param($image_path, $sel_jpg)
Add-Type -AssemblyName System.Windows.Forms;
if ($([System.Windows.Forms.Clipboard]::ContainsImage())) {
  $imageObj = [System.Drawing.Bitmap][System.Windows.Forms.Clipboard]::GetDataObject().getimage();
  if ($sel_jpg -eq "sel_jpg") {
    $imageObj.Save($image_path, [System.Drawing.Imaging.ImageFormat]::Jpeg);
  } else {
    $imageObj.Save($image_path, [System.Drawing.Imaging.ImageFormat]::Png);
  }
  return 1
} else {
  return 0
}

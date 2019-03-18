# TBitmapHelper
Adds a method to allow you to download images to bitmas via threading

## Usage
```delphi
procedure TForm1.btn1Click(Sender: TObject);
var
  I: Integer;
  LItem: TListViewItem;
begin
  lv1.BeginUpdate;
  try
    for I := 1 to 30 do
    begin
      LItem := lv1.Items.Add;
      LItem.Text := I.ToString;
      LItem.Bitmap.DownloadImage('https://ssl.comodo.com/images/https-ev-ssl.png');
    end;
  finally
    lv1.EndUpdate;
  end;
end;
```

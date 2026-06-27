program MessengerChatDemo;

uses
  Vcl.Forms,
  MainForm in 'MainForm.pas' {DemoForm},
  MessengerChatControl in '..\MessengerChatControl.pas';

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'MessengerChatDemo';
  Application.CreateForm(TDemoForm, DemoForm);
  Application.Run;
end.

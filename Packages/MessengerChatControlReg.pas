unit MessengerChatControlReg;

interface

procedure Register;

implementation

uses
  System.Classes,
  MessengerChatControl;

procedure Register;
begin
  RegisterComponents('Messenger', [TMessengerChat]);
end;

end.

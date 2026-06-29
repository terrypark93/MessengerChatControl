unit MainForm;

{$H+}

interface

uses
  System.Classes, System.SysUtils, System.Math, System.Types, Vcl.Forms,
  Vcl.Controls, Vcl.Graphics, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Menus,
  Vcl.Buttons, MessengerChatControl;

type
  { TDemoForm }

  TDemoForm = class(TForm)
    AttachMenu: TPopupMenu;
    AttachMenuFileItem: TMenuItem;
    AttachMenuPhotoItem: TMenuItem;
    AutoReplyTimer: TTimer;
    AutoSendCheck: TCheckBox;
    AttachFileButton: TButton;
    AttachPhotoButton: TButton;
    ClearButton: TButton;
    CopyButton: TButton;
    DeleteButton: TButton;
    DemoButton: TButton;
    EditButton: TButton;
    EmojiBar: TPanel;
    EmojiBarClapButton: TSpeedButton;
    EmojiBarFireButton: TSpeedButton;
    EmojiBarLaughButton: TSpeedButton;
    EmojiBarSmileButton: TSpeedButton;
    EmojiBarThumbsUpButton: TSpeedButton;
    EmojiBarWaveButton: TSpeedButton;
    EmojiButton: TButton;
    EventLog: TMemo;
    IncomingButton: TButton;
    InstructionLabel: TLabel;
    LeftPanel: TPanel;
    LeftTextLabel: TLabel;
    LogTitleLabel: TLabel;
    Messenger: TMessengerChat;
    OutgoingButton: TButton;
    ReplyButton: TButton;
    ReplyCancelButton: TButton;
    RightPanel: TPanel;
    ScrollButton: TButton;
    ThemeButton: TButton;
    TitleLabel: TLabel;
    procedure AutoReplyTimerTimer(Sender: TObject);
    procedure AutoSendCheckChange(Sender: TObject);
    procedure AttachFileButtonClick(Sender: TObject);
    procedure AttachMenuFileItemClick(Sender: TObject);
    procedure AttachMenuPhotoItemClick(Sender: TObject);
    procedure AttachPhotoButtonClick(Sender: TObject);
    procedure ClearButtonClick(Sender: TObject);
    procedure CopyButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure DemoButtonClick(Sender: TObject);
    procedure EditButtonClick(Sender: TObject);
    procedure EmojiButtonClick(Sender: TObject);
    procedure EmojiItemClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure IncomingButtonClick(Sender: TObject);
    procedure MessengerEmojiClick(Sender: TObject);
    procedure MessengerDropFiles(Sender: TObject; const FileNames: TMessengerFileNames);
    procedure MessengerMessageDblClick(Sender: TObject;
      AMessage: TMessengerMessage);
    procedure MessengerSendMessage(Sender: TObject; const AText, AReplySender,
      AReplyText: string);
    procedure OutgoingButtonClick(Sender: TObject);
    procedure ReplyButtonClick(Sender: TObject);
    procedure ReplyCancelButtonClick(Sender: TObject);
    procedure ScrollButtonClick(Sender: TObject);
    procedure ThemeButtonClick(Sender: TObject);
  private
    FHandledInitialPrompt: Boolean;
    FLastSentText: string;
    FPendingInitialFocus: Boolean;
    FSampleCounter: Integer;
    FUseAltTheme: Boolean;
    procedure AddEvent(const AText: string);
    procedure AddIncomingSample;
    procedure ApplyTheme;
    function DescribeFileSize(const AFileName: string): string;
    function IsPhotoFile(const AFileName: string): Boolean;
    procedure OpenAttachMenu(const AScreenPoint: TPoint);
    procedure OpenEmojiBar(const AScreenPoint: TPoint);
    procedure SendAttachmentFile(const AFileName: string);
    procedure SendDemoFile;
    procedure SendDemoPhoto;
    procedure SeedDemoConversation;
  end;

var
  DemoForm: TDemoForm;

implementation

{$R *.dfm}

const
  SAMPLE_SENDERS: array[0..3] of string = ('Integration Bot', 'Developer', 'UI Tester', 'Support Bot');
  SAMPLE_MESSAGES: array[0..5] of string = (
    'Use AddIncoming or AddOutgoing to append plain text messages.',
    'Double-click a bubble or call BeginReplyTo to start reply mode.',
    'Use InsertEmoji or OnEmojiClick to add emoji support 🙂',
    'Attachments are added with AddIncomingPhoto, AddOutgoingPhoto, AddIncomingFile, or AddOutgoingFile.',
    'Ctrl-click lets you select several messages for bulk copy or delete.',
    'EditMessageText updates an existing bubble, and DeleteMessage removes it.'
  );

procedure TDemoForm.FormCreate(Sender: TObject);
begin
  Color := $00F4EFE7;
  Font.Name := 'Helvetica';
  Font.Size := 11;
  LeftPanel.Color := $00EEE5D8;
  RightPanel.Color := $00F7F2EA;
  EventLog.Color := $00FFFDF9;
  Messenger.OnSendMessage := MessengerSendMessage;
  Messenger.OnAttachClick := AttachPhotoButtonClick;
  Messenger.OnDropFiles := MessengerDropFiles;
  Messenger.OnMessageDblClick := MessengerMessageDblClick;
  Messenger.OnEmojiClick := MessengerEmojiClick;
  AutoSendCheck.Checked := Messenger.AutoAddOutgoing;
  Messenger.Clear;
  Messenger.InputMemo.Text := 'Say "Hello"';
  Messenger.InputMemo.SelStart := Length(Messenger.InputMemo.Text);
  FHandledInitialPrompt := False;
  FPendingInitialFocus := True;
  AddEvent('Initial prompt prepared');
end;

procedure TDemoForm.FormActivate(Sender: TObject);
begin
  if FPendingInitialFocus and (Messenger.InputMemo <> nil)
    and Messenger.InputMemo.CanFocus then
  begin
    FPendingInitialFocus := False;
    Messenger.InputMemo.SelStart := Length(Messenger.InputMemo.Text);
    Messenger.InputMemo.SetFocus;
  end;
end;

procedure TDemoForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Messenger.HandleShortcut(Key, Shift);
end;

procedure TDemoForm.AutoReplyTimerTimer(Sender: TObject);
begin
  AutoReplyTimer.Enabled := False;
  Messenger.AddIncoming(
    'Integration Bot',
    'Demo reply received. The component forwarded your text: ' + FLastSentText,
    FormatDateTime('hh:nn', Now),
    'You',
    FLastSentText
  );
  AddEvent('Generated incoming auto reply');
end;

procedure TDemoForm.AutoSendCheckChange(Sender: TObject);
begin
  Messenger.AutoAddOutgoing := AutoSendCheck.Checked;
  AddEvent('AutoAddOutgoing = ' + BoolToStr(Messenger.AutoAddOutgoing, True));
end;

procedure TDemoForm.AttachFileButtonClick(Sender: TObject);
begin
  SendDemoFile;
end;

procedure TDemoForm.AttachMenuFileItemClick(Sender: TObject);
begin
  SendDemoFile;
end;

procedure TDemoForm.AttachMenuPhotoItemClick(Sender: TObject);
begin
  SendDemoPhoto;
end;

procedure TDemoForm.AttachPhotoButtonClick(Sender: TObject);
var
  P: TPoint;
begin
  if Sender = Messenger then
    P := Messenger.ClientToScreen(Point(24, Messenger.Height - 70))
  else
    P := AttachPhotoButton.ClientToScreen(Point(0, AttachPhotoButton.Height));
  OpenAttachMenu(P);
end;

procedure TDemoForm.SendDemoFile;
var
  FileDialog: TOpenDialog;
  FileName: string;
begin
  FileDialog := TOpenDialog.Create(Self);
  try
    FileDialog.Title := 'Select File';
    FileDialog.Filter := 'All Files|*.*';
    if not FileDialog.Execute then
      Exit;

    FileName := ExtractFileName(FileDialog.FileName);
    Messenger.AddOutgoingFile(FileName, FileDialog.FileName,
      DescribeFileSize(FileDialog.FileName), FormatDateTime('hh:nn', Now),
      'Shared a file from the demo.');
    AddEvent('Attached file: ' + FileName);
  finally
    FileDialog.Free;
  end;
end;

procedure TDemoForm.SendDemoPhoto;
var
  FileDialog: TOpenDialog;
  FileName: string;
begin
  FileDialog := TOpenDialog.Create(Self);
  try
    FileDialog.Title := 'Select Photo';
    FileDialog.Filter := 'Images|*.png;*.jpg;*.jpeg;*.bmp;*.gif;*.webp|All Files|*.*';
    if not FileDialog.Execute then
      Exit;

    FileName := ExtractFileName(FileDialog.FileName);
    Messenger.AddOutgoingPhoto(FileName, FileDialog.FileName,
      FormatDateTime('hh:nn', Now), 'Shared a photo from the demo.');
    AddEvent('Attached photo: ' + FileName);
  finally
    FileDialog.Free;
  end;
end;

procedure TDemoForm.ClearButtonClick(Sender: TObject);
begin
  Messenger.Clear;
  AddEvent('Chat cleared');
end;

procedure TDemoForm.CopyButtonClick(Sender: TObject);
begin
  if Messenger.SelectedCount > 0 then
  begin
    Messenger.CopySelectedMessages;
    if Messenger.SelectedCount = 1 then
      AddEvent('Selected message copied')
    else
      AddEvent(IntToStr(Messenger.SelectedCount) + ' selected messages copied');
  end
  else
    AddEvent('No selected messages to copy');
end;

procedure TDemoForm.DeleteButtonClick(Sender: TObject);
begin
  if Messenger.SelectedCount > 0 then
  begin
    if Messenger.SelectedCount = 1 then
      AddEvent('Selected message deleted')
    else
      AddEvent(IntToStr(Messenger.SelectedCount) + ' selected messages deleted');
    Messenger.DeleteSelectedMessages;
  end
  else
    AddEvent('No selected messages to delete');
end;

procedure TDemoForm.DemoButtonClick(Sender: TObject);
begin
  SeedDemoConversation;
end;

procedure TDemoForm.EditButtonClick(Sender: TObject);
begin
  if Messenger.SelectedCount = 1 then
  begin
    Messenger.BeginEditMessage(Messenger.SelectedMessage);
    AddEvent('Started editing selected message');
  end
  else if Messenger.SelectedCount > 1 then
    AddEvent('Editing is available only for a single selected message')
  else
    AddEvent('No selected message to edit');
end;

procedure TDemoForm.EmojiButtonClick(Sender: TObject);
var
  P: TPoint;
begin
  P := EmojiButton.ClientToScreen(Point(0, EmojiButton.Height));
  OpenEmojiBar(P);
end;

procedure TDemoForm.EmojiItemClick(Sender: TObject);
begin
  Messenger.InsertEmoji(TSpeedButton(Sender).Caption);
  AddEvent('Inserted emoji: ' + TSpeedButton(Sender).Caption);
  EmojiBar.Visible := False;
end;

procedure TDemoForm.IncomingButtonClick(Sender: TObject);
begin
  AddIncomingSample;
  AddEvent('Added incoming message');
end;

procedure TDemoForm.MessengerEmojiClick(Sender: TObject);
var
  P: TPoint;
begin
  P := Mouse.CursorPos;
  OpenEmojiBar(P);
  AddEvent('Opened emoji popup');
end;

procedure TDemoForm.MessengerDropFiles(Sender: TObject;
  const FileNames: TMessengerFileNames);
var
  I: Integer;
begin
  if Length(FileNames) = 0 then
    Exit;

  for I := Low(FileNames) to High(FileNames) do
    SendAttachmentFile(FileNames[I]);

  AddEvent(IntToStr(Length(FileNames)) + ' dropped file(s) processed');
end;

procedure TDemoForm.MessengerMessageDblClick(Sender: TObject;
  AMessage: TMessengerMessage);
begin
  Messenger.BeginReplyTo(AMessage);
  AddEvent('Reply started for message from "' + AMessage.Sender + '"');
end;

procedure TDemoForm.MessengerSendMessage(Sender: TObject; const AText,
  AReplySender, AReplyText: string);
begin
  if AReplySender <> '' then
    AddEvent('Send: ' + AText + ' | reply to ' + AReplySender)
  else
    AddEvent('Send: ' + AText);
  if AReplyText <> '' then ;
  FLastSentText := AText;
  if not FHandledInitialPrompt then
  begin
    FHandledInitialPrompt := True;
    Messenger.AddIncoming(
      'Integration Bot',
      'TMessengerChat is a Delphi VCL visual control for messenger-style interfaces with bubbles, replies, emoji, attachments, editing, deleting, and multi-select.',
      FormatDateTime('hh:nn', Now)
    );
    Messenger.AddIncoming(
      'Integration Bot',
      'Use AddIncoming/AddOutgoing for text, BeginReplyTo for quotes, AddIncomingPhoto/AddOutgoingFile for attachments, and OnSendMessage to connect your backend or Telegram bot.',
      FormatDateTime('hh:nn', Now)
    );
    AddEvent('Displayed first-run component overview');
  end
  else
    AutoReplyTimer.Enabled := True;
end;

procedure TDemoForm.OutgoingButtonClick(Sender: TObject);
begin
  Messenger.AddOutgoing(
    'This outgoing sample shows how your application can add a sent message to the chat.',
    FormatDateTime('hh:nn', Now)
  );
  AddEvent('Added outgoing message');
end;

procedure TDemoForm.ReplyButtonClick(Sender: TObject);
begin
  if Messenger.SelectedCount = 1 then
  begin
    Messenger.BeginReplyTo(Messenger.SelectedMessage);
    AddEvent('Reply started from the control panel');
  end
  else if Messenger.SelectedCount > 1 then
    AddEvent('Reply is available only for a single selected message')
  else
    AddEvent('No selected message for reply');
end;

procedure TDemoForm.ReplyCancelButtonClick(Sender: TObject);
begin
  Messenger.CancelReply;
  AddEvent('Reply cleared');
end;

procedure TDemoForm.ScrollButtonClick(Sender: TObject);
begin
  Messenger.ScrollToBottom;
  AddEvent('Scrolled to bottom');
end;

procedure TDemoForm.ThemeButtonClick(Sender: TObject);
begin
  FUseAltTheme := not FUseAltTheme;
  ApplyTheme;
  AddEvent('Theme switched');
end;

procedure TDemoForm.AddEvent(const AText: string);
begin
  EventLog.Lines.Add(FormatDateTime('hh:nn:ss', Now) + '  ' + AText);
  EventLog.SelStart := Length(EventLog.Text);
end;

procedure TDemoForm.AddIncomingSample;
var
  SenderIndex: Integer;
  MessageIndex: Integer;
begin
  SenderIndex := FSampleCounter mod Length(SAMPLE_SENDERS);
  MessageIndex := FSampleCounter mod Length(SAMPLE_MESSAGES);
  Messenger.AddIncoming(
    SAMPLE_SENDERS[SenderIndex],
    SAMPLE_MESSAGES[MessageIndex],
    FormatDateTime('hh:nn', Now)
  );
  Inc(FSampleCounter);
end;

procedure TDemoForm.ApplyTheme;
begin
  if FUseAltTheme then
  begin
    Color := $00EDF5FA;
    LeftPanel.Color := $00DCEAF2;
    RightPanel.Color := $00F3F8FB;
    EventLog.Color := $00F9FDFF;
    Messenger.BackgroundColor := $00EAF5FB;
    Messenger.BubbleIncomingColor := clWhite;
    Messenger.BubbleOutgoingColor := $00D8F0FF;
    Messenger.ComposerColor := $00D7E8F1;
  end
  else
  begin
    Color := $00F4EFE7;
    LeftPanel.Color := $00EEE5D8;
    RightPanel.Color := $00F7F2EA;
    EventLog.Color := $00FFFDF9;
    Messenger.BackgroundColor := $00F6F1EA;
    Messenger.BubbleIncomingColor := clWhite;
    Messenger.BubbleOutgoingColor := $00D7F8C6;
    Messenger.ComposerColor := $00F0E9DE;
  end;
end;

function TDemoForm.DescribeFileSize(const AFileName: string): string;
var
  Info: TSearchRec;
  Bytes: Int64;
begin
  Result := '';
  if FindFirst(AFileName, faAnyFile, Info) <> 0 then
    Exit;
  try
    Bytes := Info.Size;
  finally
    System.SysUtils.FindClose(Info);
  end;

  if Bytes >= 1024 * 1024 then
    Result := FormatFloat('0.0 MB', Bytes / (1024 * 1024))
  else if Bytes >= 1024 then
    Result := FormatFloat('0.0 KB', Bytes / 1024)
  else
    Result := IntToStr(Bytes) + ' B';
end;

function TDemoForm.IsPhotoFile(const AFileName: string): Boolean;
var
  Ext: String;
begin
  Ext := LowerCase(ExtractFileExt(AFileName));
  Result := (Ext = '.png') or (Ext = '.jpg') or (Ext = '.jpeg')
    or (Ext = '.bmp') or (Ext = '.gif') or (Ext = '.webp')
    or (Ext = '.tif') or (Ext = '.tiff');
end;

procedure TDemoForm.OpenAttachMenu(const AScreenPoint: TPoint);
begin
  AttachMenu.PopUp(AScreenPoint.X, AScreenPoint.Y);
end;

procedure TDemoForm.OpenEmojiBar(const AScreenPoint: TPoint);
var
  P: TPoint;
begin
  P := ScreenToClient(AScreenPoint);
  EmojiBar.Left := Max(12, Min(ClientWidth - EmojiBar.Width - 12, P.X));
  EmojiBar.Top := Max(12, Min(ClientHeight - EmojiBar.Height - 12, P.Y));
  EmojiBar.Visible := True;
  EmojiBar.BringToFront;
end;

procedure TDemoForm.SendAttachmentFile(const AFileName: string);
var
  BaseName: String;
begin
  if (AFileName = '') or (not FileExists(AFileName)) then
    Exit;

  BaseName := ExtractFileName(AFileName);
  if IsPhotoFile(AFileName) then
  begin
    Messenger.AddOutgoingPhoto(BaseName, AFileName,
      FormatDateTime('hh:nn', Now), 'Shared via drag and drop.');
    AddEvent('Dropped photo: ' + BaseName);
  end
  else
  begin
    Messenger.AddOutgoingFile(BaseName, AFileName, DescribeFileSize(AFileName),
      FormatDateTime('hh:nn', Now), 'Shared via drag and drop.');
    AddEvent('Dropped file: ' + BaseName);
  end;
end;

procedure TDemoForm.SeedDemoConversation;
var
  DemoIconFilePath: string;
  DemoPhotoPath: string;
  DemoFilePath: string;
  DemoSecondPhotoPath: string;
begin
  Messenger.Clear;
  FHandledInitialPrompt := True;
  DemoPhotoPath := ExpandFileName(ExtractFilePath(Application.ExeName) + '../TMessengerChat.png');
  DemoSecondPhotoPath := ExpandFileName(ExtractFilePath(Application.ExeName) + '../MessengerChatControl.TMessengerChat.png');
  DemoFilePath := ExpandFileName(ExtractFilePath(Application.ExeName) + '../README.md');
  DemoIconFilePath := ExpandFileName(ExtractFilePath(Application.ExeName) + '../messenger_icon.svg');

  Messenger.AddIncoming('Integration Bot',
    'Welcome. This demo conversation explains the component through a realistic chat flow.',
    '10:12');
  Messenger.AddOutgoing(
    'Start with AddIncoming or AddOutgoing when you need to show a normal text message.',
    '10:13'
  );
  Messenger.AddIncoming(
    'Developer',
    'If you want a quoted reply, double-click a bubble in the UI or call BeginReplyTo in code.',
    '10:14',
    'Integration Bot',
    'Welcome. This demo conversation explains the component through a realistic chat flow.'
  );
  Messenger.AddOutgoing(
    'When the send event fires, your app can push the text to Telegram, a REST backend, or any custom transport.',
    '10:15',
    'Developer',
    'If you want a quoted reply, double-click a bubble in the UI or call BeginReplyTo in code.'
  );
  Messenger.AddIncomingPhoto('UI Tester', ExtractFileName(DemoPhotoPath), DemoPhotoPath, '10:16',
    'This PNG is a real project image attached through AddIncomingPhoto.');
  Messenger.AddOutgoingPhoto(ExtractFileName(DemoSecondPhotoPath), DemoSecondPhotoPath, '10:17',
    'Outgoing photos use the same attachment API and now keep their aspect ratio.');
  Messenger.AddOutgoingFile('README.md', DemoFilePath, DescribeFileSize(DemoFilePath),
    '10:18', 'This is the real README file from the project root.');
  Messenger.AddIncomingFile('Support Bot', ExtractFileName(DemoIconFilePath), DemoIconFilePath,
    DescribeFileSize(DemoIconFilePath), '10:19',
    'File bubbles can point to any local document, image, archive, or media file.');
  Messenger.AddIncoming('Integration Bot',
    'To enable bulk actions, select messages with Ctrl-click. The top selection bar gives Copy, Edit, and Delete.',
    '10:20');
  Messenger.AddOutgoing(
    'Emoji, editing, deleting, replying, attachments, and theme switching are all demonstrated in this project.',
    '10:21'
  );
  ApplyTheme;
  AddEvent('Demo conversation loaded');
end;

end.


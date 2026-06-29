{
  TMessengerChat
  Copyright (c) 2020 Anton Lindeberg

  Released under the MIT License.

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
}

unit MessengerChatControl;

{$H+}

interface

uses
  System.Classes, System.SysUtils, System.Math, System.Types, System.Contnrs,
  Winapi.Windows, Winapi.Messages, Winapi.ShellAPI, Vcl.Controls, Vcl.Graphics,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Forms, Vcl.Menus, Vcl.Clipbrd;

type
  TMessengerMessageKind = (mmText, mmPhoto, mmFile);

  TMessengerMessage = class
  private
    FAttachmentDetails: string;
    FAttachmentName: string;
    FAttachmentPath: string;
    FID: Integer;
    FKind: TMessengerMessageKind;
    FSender: string;
    FText: string;
    FTimeText: string;
    FOutgoing: Boolean;
    FPreviewBitmap: TBitmap;
    FQuoteSender: string;
    FQuoteText: string;
  public
    constructor Create;
    destructor Destroy; override;
    property ID: Integer read FID write FID;
    property Kind: TMessengerMessageKind read FKind write FKind;
    property Sender: string read FSender write FSender;
    property Text: string read FText write FText;
    property TimeText: string read FTimeText write FTimeText;
    property Outgoing: Boolean read FOutgoing write FOutgoing;
    property QuoteSender: string read FQuoteSender write FQuoteSender;
    property QuoteText: string read FQuoteText write FQuoteText;
    property AttachmentName: string read FAttachmentName write FAttachmentName;
    property AttachmentPath: string read FAttachmentPath write FAttachmentPath;
    property AttachmentDetails: string read FAttachmentDetails write FAttachmentDetails;
    property PreviewBitmap: TBitmap read FPreviewBitmap;
  end;

  TMessengerFileNames = TArray<string>;

  TMessengerSendEvent = procedure(Sender: TObject; const AText, AReplySender,
    AReplyText: string) of object;
  TMessengerMessageEvent = procedure(Sender: TObject; AMessage: TMessengerMessage)
    of object;
  TMessengerDropFilesEvent = procedure(Sender: TObject;
    const FileNames: TMessengerFileNames) of object;

  { TMessengerChat }

  TMessengerChat = class(TCustomControl)
  private
    type
      TMessageLayout = record
        Message: TMessengerMessage;
        BubbleRect: TRect;
        QuoteRect: TRect;
        AttachmentRect: TRect;
        TextRect: TRect;
        TimeRect: TRect;
      end;
  private
    FAutoAddOutgoing: Boolean;
    FAttachButton: TSpeedButton;
    FBackgroundColor: TColor;
    FBubbleIncomingColor: TColor;
    FBubbleOutgoingColor: TColor;
    FComposerColor: TColor;
    FContextMessage: TMessengerMessage;
    FContextMenu: TPopupMenu;
    FCurrentReplySender: string;
    FCurrentReplyText: string;
    FEditingMessage: TMessengerMessage;
    FEmojiButton: TSpeedButton;
    FInput: TMemo;
    FLayouts: array of TMessageLayout;
    FSelectionBar: TPanel;
    FSelectionCloseButton: TSpeedButton;
    FSelectionCopyButton: TSpeedButton;
    FSelectionDeleteButton: TSpeedButton;
    FSelectionEditButton: TSpeedButton;
    FSelectionInfoLabel: TLabel;
    FMenuSelectItem: TMenuItem;
    FMenuCopyItem: TMenuItem;
    FMenuDeleteItem: TMenuItem;
    FMenuEditItem: TMenuItem;
    FMessages: TObjectList;
    FNextID: Integer;
    FOnAttachClick: TNotifyEvent;
    FOnEmojiClick: TNotifyEvent;
    FOnDropFiles: TMessengerDropFilesEvent;
    FOnMessageDblClick: TMessengerMessageEvent;
    FOnSendMessage: TMessengerSendEvent;
    FReplyCancelButton: TSpeedButton;
    FScrollbar: TScrollBar;
    FSelectedMessage: TMessengerMessage;
    FSelectedMessages: TList;
    FSendButton: TSpeedButton;
    FUpdatingScrollbar: Boolean;
    procedure ClearSelection;
    procedure CancelReplyClick(Sender: TObject);
    procedure AttachButtonClick(Sender: TObject);
    procedure ContextCopyClick(Sender: TObject);
    procedure ContextDeleteClick(Sender: TObject);
    procedure ContextEditClick(Sender: TObject);
    procedure ContextSelectClick(Sender: TObject);
    function ComposerHeight: Integer;
    function ContentHeight: Integer;
    procedure EmojiButtonClick(Sender: TObject);
    function FindLayoutIndexAt(const P: TPoint): Integer;
    function FindMessageAt(const P: TPoint): TMessengerMessage;
    function GetMessage(Index: Integer): TMessengerMessage;
    function GetMessageCount: Integer;
    function GetMessagePreviewText(AMessage: TMessengerMessage): string;
    function GetPreviewHeight: Integer;
    function GetSelectedCount: Integer;
    function GetSelectionToggleRect(const ABubbleRect: TRect): TRect;
    function GetSelectionBarHeight: Integer;
    function HasShortcutModifier(Shift: TShiftState): Boolean;
    function IndexOfMessage(AMessage: TMessengerMessage): Integer;
    procedure InputKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure InputChange(Sender: TObject);
    procedure FocusInputIfPossible;
    function IsEditing: Boolean;
    function IsMessageSelected(AMessage: TMessengerMessage): Boolean;
    function IsSelectionMode: Boolean;
    procedure LayoutChildren;
    procedure LoadPhotoPreview(AMessage: TMessengerMessage; const AFileName: string);
    procedure OpenAttachment(AMessage: TMessengerMessage);
    procedure RebuildLayout;
    procedure ScrollbarChange(Sender: TObject);
    procedure SendButtonClick(Sender: TObject);
    procedure SetBackgroundColor(AValue: TColor);
    procedure SetBubbleIncomingColor(AValue: TColor);
    procedure SetBubbleOutgoingColor(AValue: TColor);
    procedure SetComposerColor(AValue: TColor);
    procedure SelectionCloseClick(Sender: TObject);
    procedure SelectionCopyClick(Sender: TObject);
    procedure SelectionDeleteClick(Sender: TObject);
    procedure SelectionEditClick(Sender: TObject);
    procedure HandleMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer;
      MousePos: TPoint; var Handled: Boolean);
    procedure UpdateActionButtons;
    procedure UpdateScrollbar;
  protected
    function AttachmentHeight(AMessage: TMessengerMessage; ABubbleWidth: Integer): Integer;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure DblClick; override;
    procedure Paint; override;
    procedure Resize; override;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    procedure WMDropFiles(var Message: TWMDropFiles); message WM_DROPFILES;
    function WrapTextHeight(const AText: string; AWidth: Integer): Integer;
    procedure DrawBubble(const ALayout: TMessageLayout);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function AddIncoming(const ASender, AText, ATimeText: string;
      const AQuoteSender: string = ''; const AQuoteText: string = ''): TMessengerMessage;
    function AddIncomingFile(const ASender, AFileName, AFilePath, AFileSizeText,
      ATimeText: string; const ACaption: string = ''; const AQuoteSender: string = '';
      const AQuoteText: string = ''): TMessengerMessage;
    function AddIncomingPhoto(const ASender, AFileName, AFilePath, ATimeText: string;
      const ACaption: string = ''; const AQuoteSender: string = '';
      const AQuoteText: string = ''): TMessengerMessage;
    function AddOutgoing(const AText, ATimeText: string;
      const AQuoteSender: string = ''; const AQuoteText: string = ''): TMessengerMessage;
    function AddOutgoingFile(const AFileName, AFilePath, AFileSizeText, ATimeText: string;
      const ACaption: string = ''; const AQuoteSender: string = '';
      const AQuoteText: string = ''): TMessengerMessage;
    function AddOutgoingPhoto(const AFileName, AFilePath, ATimeText: string;
      const ACaption: string = ''; const AQuoteSender: string = '';
      const AQuoteText: string = ''): TMessengerMessage;
    function AddMessage(const ASender, AText, ATimeText: string; AOutgoing: Boolean;
      const AQuoteSender: string = ''; const AQuoteText: string = ''): TMessengerMessage;
    function AddAttachmentMessage(const ASender, AText, ATimeText: string;
      AOutgoing: Boolean; AKind: TMessengerMessageKind; const AAttachmentName,
      AAttachmentPath, AAttachmentDetails: string; const AQuoteSender: string = '';
      const AQuoteText: string = ''): TMessengerMessage;
    procedure BeginEditMessage(AMessage: TMessengerMessage);
    procedure BeginReplyTo(AMessage: TMessengerMessage);
    procedure CancelReply;
    procedure CancelEdit;
    procedure Clear;
    procedure CopyMessageText(AMessage: TMessengerMessage);
    procedure CopySelectedMessage;
    procedure CopySelectedMessages;
    procedure DeleteMessage(AMessage: TMessengerMessage);
    procedure DeleteSelectedMessage;
    procedure DeleteSelectedMessages;
    procedure EditMessageText(AMessage: TMessengerMessage; const ANewText: string);
    function HandleShortcut(var Key: Word; Shift: TShiftState): Boolean;
    procedure InsertEmoji(const AEmoji: string);
    procedure ScrollToBottom;
    procedure ToggleMessageSelection(AMessage: TMessengerMessage);
    property EditingMessage: TMessengerMessage read FEditingMessage;
    property Messages[Index: Integer]: TMessengerMessage read GetMessage;
    property MessageCount: Integer read GetMessageCount;
    property InputMemo: TMemo read FInput;
    property SelectedCount: Integer read GetSelectedCount;
    property SelectedMessage: TMessengerMessage read FSelectedMessage;
  published
    property Align;
    property Anchors;
    property AutoAddOutgoing: Boolean read FAutoAddOutgoing write FAutoAddOutgoing default True;
    property BackgroundColor: TColor read FBackgroundColor write SetBackgroundColor default $00F6F1EA;
    property BubbleIncomingColor: TColor read FBubbleIncomingColor write SetBubbleIncomingColor default clWhite;
    property BubbleOutgoingColor: TColor read FBubbleOutgoingColor write SetBubbleOutgoingColor default $00D7F8C6;
    property ComposerColor: TColor read FComposerColor write SetComposerColor default $00F0E9DE;
    property Color;
    property Constraints;
    property Font;
    property ParentColor;
    property ParentFont;
    property PopupMenu;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnAttachClick: TNotifyEvent read FOnAttachClick write FOnAttachClick;
    property OnDropFiles: TMessengerDropFilesEvent read FOnDropFiles write FOnDropFiles;
    property OnEmojiClick: TNotifyEvent read FOnEmojiClick write FOnEmojiClick;
    property OnMessageDblClick: TMessengerMessageEvent read FOnMessageDblClick write FOnMessageDblClick;
    property OnSendMessage: TMessengerSendEvent read FOnSendMessage write FOnSendMessage;
  end;

implementation

const
  SIDE_MARGIN = 14;
  TOP_MARGIN = 12;
  BUBBLE_PADDING_X = 12;
  BUBBLE_PADDING_Y = 10;
  QUOTE_BAR_WIDTH = 4;
  QUOTE_GAP = 8;
  MESSAGE_GAP = 10;
  COMPOSER_BASE_HEIGHT = 72;
  REPLY_PREVIEW_HEIGHT = 42;
  SCROLL_STEP = 56;
  PHOTO_BLOCK_HEIGHT = 132;
  FILE_BLOCK_HEIGHT = 58;
  SELECTION_GUTTER = 30;

function FormatByteSize(ABytes: Int64): string;
const
  KB = 1024;
  MB = 1024 * 1024;
  GB = 1024 * 1024 * 1024;
begin
  if ABytes >= GB then
    Result := FormatFloat('0.0 GB', ABytes / GB)
  else if ABytes >= MB then
    Result := FormatFloat('0.0 MB', ABytes / MB)
  else if ABytes >= KB then
    Result := FormatFloat('0.0 KB', ABytes / KB)
  else
    Result := IntToStr(ABytes) + ' B';
end;

function TryGetFileSize(const AFileName: string; out AFileSize: Int64): Boolean;
var
  Info: TSearchRec;
begin
  Result := FindFirst(AFileName, faAnyFile, Info) = 0;
  if Result then
  begin
    AFileSize := Info.Size;
    System.SysUtils.FindClose(Info);
  end
  else
    AFileSize := 0;
end;

function RectHeight(const R: TRect): Integer; inline;
begin
  Result := R.Bottom - R.Top;
end;

function RectWidth(const R: TRect): Integer; inline;
begin
  Result := R.Right - R.Left;
end;

function FitRectIntoRect(const SourceSize: TPoint; const TargetRect: TRect): TRect;
var
  Scale: Double;
  W: Integer;
  H: Integer;
begin
  if (SourceSize.X <= 0) or (SourceSize.Y <= 0) then
    Exit(TargetRect);

  Scale := Min(RectWidth(TargetRect) / SourceSize.X, RectHeight(TargetRect) / SourceSize.Y);
  W := Max(1, Round(SourceSize.X * Scale));
  H := Max(1, Round(SourceSize.Y * Scale));
  Result := Rect(
    TargetRect.Left + (RectWidth(TargetRect) - W) div 2,
    TargetRect.Top + (RectHeight(TargetRect) - H) div 2,
    TargetRect.Left + (RectWidth(TargetRect) - W) div 2 + W,
    TargetRect.Top + (RectHeight(TargetRect) - H) div 2 + H
  );
end;

{ TMessengerMessage }

constructor TMessengerMessage.Create;
begin
  inherited Create;
  FKind := mmText;
  FPreviewBitmap := TBitmap.Create;
end;

destructor TMessengerMessage.Destroy;
begin
  FPreviewBitmap.Free;
  inherited Destroy;
end;

{ TMessengerChat }

constructor TMessengerChat.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csOpaque, csDoubleClicks];
  Width := 420;
  Height := 720;
  Color := clWhite;
  ParentColor := False;
  DoubleBuffered := True;

  FAutoAddOutgoing := True;
  FBackgroundColor := $00F6F1EA;
  FBubbleIncomingColor := clWhite;
  FBubbleOutgoingColor := $00D7F8C6;
  FComposerColor := $00F0E9DE;
  FMessages := TObjectList.Create(True);
  FSelectedMessages := TList.Create;
  FNextID := 1;

  FScrollbar := TScrollBar.Create(Self);
  FScrollbar.Parent := Self;
  FScrollbar.Kind := sbVertical;
  FScrollbar.Anchors := [akTop, akRight, akBottom];
  FScrollbar.TabStop := False;
  FScrollbar.OnChange := ScrollbarChange;
  FScrollbar.SmallChange := SCROLL_STEP div 2;
  FScrollbar.LargeChange := 120;

  FInput := TMemo.Create(Self);
  FInput.Parent := Self;
  FInput.ScrollBars := ssNone;
  FInput.WordWrap := True;
  FInput.BorderStyle := bsNone;
  FInput.OnChange := InputChange;
  FInput.OnKeyDown := InputKeyDown;
  FInput.Font.Assign(Font);
  FInput.Font.Size := 11;
  FInput.TextHint := 'Message';

  FAttachButton := TSpeedButton.Create(Self);
  FAttachButton.Parent := Self;
  FAttachButton.Caption := '+';
  FAttachButton.Flat := True;
  FAttachButton.OnClick := AttachButtonClick;

  FEmojiButton := TSpeedButton.Create(Self);
  FEmojiButton.Parent := Self;
  FEmojiButton.Caption := '☺';
  FEmojiButton.Flat := True;
  FEmojiButton.OnClick := EmojiButtonClick;

  FSendButton := TSpeedButton.Create(Self);
  FSendButton.Parent := Self;
  FSendButton.Caption := 'Send';
  FSendButton.Flat := True;
  FSendButton.OnClick := SendButtonClick;

  FReplyCancelButton := TSpeedButton.Create(Self);
  FReplyCancelButton.Parent := Self;
  FReplyCancelButton.Caption := '×';
  FReplyCancelButton.Flat := True;
  FReplyCancelButton.Visible := False;
  FReplyCancelButton.OnClick := CancelReplyClick;

  FSelectionBar := TPanel.Create(Self);
  FSelectionBar.Parent := Self;
  FSelectionBar.BevelOuter := bvNone;
  FSelectionBar.Color := $00E9F2FB;
  FSelectionBar.ParentBackground := False;
  FSelectionBar.Visible := False;

  FSelectionCloseButton := TSpeedButton.Create(Self);
  FSelectionCloseButton.Parent := FSelectionBar;
  FSelectionCloseButton.Caption := 'Close';
  FSelectionCloseButton.Flat := True;
  FSelectionCloseButton.OnClick := SelectionCloseClick;

  FSelectionInfoLabel := TLabel.Create(Self);
  FSelectionInfoLabel.Parent := FSelectionBar;
  FSelectionInfoLabel.AutoSize := False;
  FSelectionInfoLabel.Caption := '0 selected';
  FSelectionInfoLabel.Font.Style := [fsBold];

  FSelectionCopyButton := TSpeedButton.Create(Self);
  FSelectionCopyButton.Parent := FSelectionBar;
  FSelectionCopyButton.Caption := 'Copy';
  FSelectionCopyButton.Flat := True;
  FSelectionCopyButton.OnClick := SelectionCopyClick;

  FSelectionEditButton := TSpeedButton.Create(Self);
  FSelectionEditButton.Parent := FSelectionBar;
  FSelectionEditButton.Caption := 'Edit';
  FSelectionEditButton.Flat := True;
  FSelectionEditButton.OnClick := SelectionEditClick;

  FSelectionDeleteButton := TSpeedButton.Create(Self);
  FSelectionDeleteButton.Parent := FSelectionBar;
  FSelectionDeleteButton.Caption := 'Delete';
  FSelectionDeleteButton.Flat := True;
  FSelectionDeleteButton.OnClick := SelectionDeleteClick;

  FContextMenu := TPopupMenu.Create(Self);

  FMenuSelectItem := TMenuItem.Create(FContextMenu);
  FMenuSelectItem.Caption := 'Select';
  FMenuSelectItem.OnClick := ContextSelectClick;
  FContextMenu.Items.Add(FMenuSelectItem);

  FMenuCopyItem := TMenuItem.Create(FContextMenu);
  FMenuCopyItem.Caption := 'Copy';
  FMenuCopyItem.OnClick := ContextCopyClick;
  FContextMenu.Items.Add(FMenuCopyItem);

  FMenuEditItem := TMenuItem.Create(FContextMenu);
  FMenuEditItem.Caption := 'Edit';
  FMenuEditItem.OnClick := ContextEditClick;
  FContextMenu.Items.Add(FMenuEditItem);

  FMenuDeleteItem := TMenuItem.Create(FContextMenu);
  FMenuDeleteItem.Caption := 'Delete';
  FMenuDeleteItem.OnClick := ContextDeleteClick;
  FContextMenu.Items.Add(FMenuDeleteItem);

  OnMouseWheel := HandleMouseWheel;

  LayoutChildren;
end;

destructor TMessengerChat.Destroy;
begin
  FSelectedMessages.Free;
  FMessages.Free;
  inherited Destroy;
end;

procedure TMessengerChat.ClearSelection;
begin
  FSelectedMessages.Clear;
  FSelectedMessage := nil;
  UpdateActionButtons;
end;

procedure TMessengerChat.CancelReplyClick(Sender: TObject);
begin
  if IsEditing then
    CancelEdit
  else
    CancelReply;
end;

procedure TMessengerChat.AttachButtonClick(Sender: TObject);
begin
  if Assigned(FOnAttachClick) then
    FOnAttachClick(Self);
end;

procedure TMessengerChat.ContextCopyClick(Sender: TObject);
begin
  CopySelectedMessage;
end;

procedure TMessengerChat.ContextDeleteClick(Sender: TObject);
begin
  DeleteSelectedMessage;
end;

procedure TMessengerChat.ContextEditClick(Sender: TObject);
begin
  if SelectedCount = 1 then
    BeginEditMessage(FSelectedMessage)
  else if FContextMessage <> nil then
    BeginEditMessage(FContextMessage);
end;

procedure TMessengerChat.ContextSelectClick(Sender: TObject);
begin
  if FContextMessage = nil then
    Exit;

  ClearSelection;
  FSelectedMessages.Add(FContextMessage);
  FSelectedMessage := FContextMessage;
  UpdateActionButtons;
  LayoutChildren;
  Invalidate;
end;

function TMessengerChat.ComposerHeight: Integer;
begin
  Result := COMPOSER_BASE_HEIGHT;
  Inc(Result, GetPreviewHeight);
end;

function TMessengerChat.ContentHeight: Integer;
var
  I: Integer;
begin
  Result := TOP_MARGIN + GetSelectionBarHeight;
  for I := 0 to High(FLayouts) do
    Result := Max(Result, FLayouts[I].BubbleRect.Bottom + MESSAGE_GAP);
end;

procedure TMessengerChat.EmojiButtonClick(Sender: TObject);
begin
  if Assigned(FOnEmojiClick) then
    FOnEmojiClick(Self)
  else
    InsertEmoji('🙂');
end;

function TMessengerChat.FindMessageAt(const P: TPoint): TMessengerMessage;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to High(FLayouts) do
    if PtInRect(FLayouts[I].BubbleRect, P) then
      Exit(FLayouts[I].Message);
end;

function TMessengerChat.FindLayoutIndexAt(const P: TPoint): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to High(FLayouts) do
    if PtInRect(FLayouts[I].BubbleRect, P)
      or (IsSelectionMode and PtInRect(GetSelectionToggleRect(FLayouts[I].BubbleRect), P)) then
      Exit(I);
end;

function TMessengerChat.GetMessage(Index: Integer): TMessengerMessage;
begin
  Result := TMessengerMessage(FMessages[Index]);
end;

function TMessengerChat.GetMessageCount: Integer;
begin
  Result := FMessages.Count;
end;

function TMessengerChat.GetMessagePreviewText(AMessage: TMessengerMessage): string;
begin
  Result := '';
  if AMessage = nil then
    Exit;

  if AMessage.Text <> '' then
    Exit(AMessage.Text);

  case AMessage.Kind of
    mmPhoto:
      if AMessage.AttachmentName <> '' then
        Result := '[Photo] ' + AMessage.AttachmentName
      else
        Result := '[Photo]';
    mmFile:
      if AMessage.AttachmentName <> '' then
        Result := '[File] ' + AMessage.AttachmentName
      else
        Result := '[File]';
  end;
end;

function TMessengerChat.GetPreviewHeight: Integer;
begin
  if IsEditing or (FCurrentReplyText <> '') then
    Result := REPLY_PREVIEW_HEIGHT
  else
    Result := 0;
end;

function TMessengerChat.GetSelectedCount: Integer;
begin
  Result := FSelectedMessages.Count;
end;

function TMessengerChat.GetSelectionToggleRect(const ABubbleRect: TRect): TRect;
begin
  Result := Rect(ABubbleRect.Left - 24, ABubbleRect.Top + 10, ABubbleRect.Left - 6, ABubbleRect.Top + 28);
end;

function TMessengerChat.GetSelectionBarHeight: Integer;
begin
  if IsSelectionMode then
    Result := 52
  else
    Result := 0;
end;

function TMessengerChat.HasShortcutModifier(Shift: TShiftState): Boolean;
begin
  Result := ssCtrl in Shift;
end;

function TMessengerChat.IndexOfMessage(AMessage: TMessengerMessage): Integer;
var
  I: Integer;
begin
  Result := -1;
  if AMessage = nil then
    Exit;
  for I := 0 to FMessages.Count - 1 do
    if TMessengerMessage(FMessages[I]) = AMessage then
      Exit(I);
end;

procedure TMessengerChat.InputKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  HandleShortcut(Key, Shift);
end;

procedure TMessengerChat.InputChange(Sender: TObject);
begin
  LayoutChildren;
end;

procedure TMessengerChat.FocusInputIfPossible;
var
  ParentForm: TCustomForm;
begin
  if FInput = nil then
    Exit;

  ParentForm := GetParentForm(Self);
  if (ParentForm = nil) or not ParentForm.Showing or not ParentForm.Enabled
    or (csDestroying in ParentForm.ComponentState) or not ParentForm.Active then
    Exit;

  if FInput.CanFocus then
    FInput.SetFocus;
end;

function TMessengerChat.IsEditing: Boolean;
begin
  Result := FEditingMessage <> nil;
end;

function TMessengerChat.IsMessageSelected(AMessage: TMessengerMessage): Boolean;
begin
  Result := (AMessage <> nil) and (FSelectedMessages.IndexOf(AMessage) >= 0);
end;

function TMessengerChat.IsSelectionMode: Boolean;
begin
  Result := SelectedCount > 0;
end;

procedure TMessengerChat.LoadPhotoPreview(AMessage: TMessengerMessage;
  const AFileName: string);
var
  Picture: TPicture;
begin
  if (AMessage = nil) or (AFileName = '') or (not FileExists(AFileName)) then
    Exit;

  Picture := TPicture.Create;
  try
    try
      Picture.LoadFromFile(AFileName);
      if (Picture.Graphic <> nil) and (not Picture.Graphic.Empty) then
      begin
        AMessage.PreviewBitmap.Assign(Picture.Graphic);
        AMessage.AttachmentDetails := IntToStr(Picture.Width) + ' x ' + IntToStr(Picture.Height);
      end;
    except
      AMessage.PreviewBitmap.SetSize(0, 0);
    end;
  finally
    Picture.Free;
  end;
end;

procedure TMessengerChat.OpenAttachment(AMessage: TMessengerMessage);
begin
  if (AMessage = nil) or (AMessage.Kind = mmText) then
    Exit;
  if (AMessage.AttachmentPath = '') or (not FileExists(AMessage.AttachmentPath)) then
    Exit;
  ShellExecute(Handle, PChar('open'), PChar(AMessage.AttachmentPath), nil, nil, SW_SHOWNORMAL);
end;

procedure TMessengerChat.LayoutChildren;
var
  CHeight: Integer;
  InputTop: Integer;
  PreviewHeight: Integer;
  SelectionBarHeight: Integer;
begin
  if (FScrollbar = nil) or (FInput = nil) or (FAttachButton = nil)
    or (FInput = nil) or (FEmojiButton = nil)
    or (FSendButton = nil) or (FReplyCancelButton = nil)
    or (FSelectionBar = nil) then
    Exit;

  CHeight := ComposerHeight;
  PreviewHeight := GetPreviewHeight;
  SelectionBarHeight := GetSelectionBarHeight;

  FSelectionBar.Visible := SelectionBarHeight > 0;
  if FSelectionBar.Visible then
  begin
    FSelectionBar.SetBounds(0, 0, Width, SelectionBarHeight);
    FSelectionCloseButton.SetBounds(12, 10, 56, 28);
    FSelectionInfoLabel.SetBounds(80, 15, 120, 18);
    FSelectionDeleteButton.SetBounds(Max(0, Width - 74), 10, 62, 28);
    FSelectionEditButton.SetBounds(Max(0, Width - 142), 10, 58, 28);
    FSelectionCopyButton.SetBounds(Max(0, Width - 210), 10, 58, 28);
  end;

  FScrollbar.SetBounds(Max(0, Width - 12), SelectionBarHeight, 12,
    Max(0, Height - CHeight - SelectionBarHeight));

  InputTop := Height - CHeight + 14;
  if PreviewHeight > 0 then
  begin
    Inc(InputTop, PreviewHeight);
    FReplyCancelButton.Visible := True;
    FReplyCancelButton.SetBounds(Max(0, Width - 52), Max(0, Height - CHeight + 4), 28, 22);
  end
  else
    FReplyCancelButton.Visible := False;

  if IsEditing then
    FSendButton.Caption := 'Save'
  else
    FSendButton.Caption := 'Send';

  FAttachButton.SetBounds(14, InputTop + 6, 28, 28);
  FEmojiButton.SetBounds(46, InputTop + 6, 28, 28);
  FSendButton.SetBounds(Max(0, Width - 62), InputTop + 4, 46, 32);
  FInput.SetBounds(80, InputTop + 4, Max(80, Width - 154), 40);

  UpdateActionButtons;
  UpdateScrollbar;
  Invalidate;
end;

procedure TMessengerChat.RebuildLayout;
var
  I: Integer;
  DrawAreaWidth: Integer;
  BubbleMaxWidth: Integer;
  CursorY: Integer;
  BubbleWidth: Integer;
  BubbleHeight: Integer;
  LeftPos: Integer;
  SelectionOffset: Integer;
  AttachmentBlockHeight: Integer;
  QuoteHeight: Integer;
  TextHeight: Integer;
  MetaHeight: Integer;
  TextTop: Integer;
  QuoteBlockLeft: Integer;
  QuoteBlockTop: Integer;
  Msg: TMessengerMessage;
begin
  if IsSelectionMode then
    SelectionOffset := SELECTION_GUTTER
  else
    SelectionOffset := 0;

  DrawAreaWidth := Max(120, Width - FScrollbar.Width - 8 - SelectionOffset);
  BubbleMaxWidth := Max(140, Round(DrawAreaWidth * 0.72));
  CursorY := TOP_MARGIN + GetSelectionBarHeight;
  SetLength(FLayouts, FMessages.Count);

  Canvas.Font.Assign(Font);
  Canvas.Font.Size := 10;

  for I := 0 to FMessages.Count - 1 do
  begin
    Msg := TMessengerMessage(FMessages[I]);
    if Msg.Text <> '' then
      TextHeight := WrapTextHeight(Msg.Text, BubbleMaxWidth - (BUBBLE_PADDING_X * 2))
    else
      TextHeight := 0;
    QuoteHeight := 0;
    if (Msg.QuoteSender <> '') or (Msg.QuoteText <> '') then
      QuoteHeight := 18 + WrapTextHeight(Msg.QuoteText, BubbleMaxWidth - (BUBBLE_PADDING_X * 2) - QUOTE_BAR_WIDTH - QUOTE_GAP);
    AttachmentBlockHeight := AttachmentHeight(Msg, BubbleMaxWidth - (BUBBLE_PADDING_X * 2));

    MetaHeight := 16;
    BubbleHeight := BUBBLE_PADDING_Y * 2 + TextHeight + MetaHeight + AttachmentBlockHeight;
    if QuoteHeight > 0 then
      Inc(BubbleHeight, QuoteHeight + 8);
    if (AttachmentBlockHeight > 0) and (TextHeight > 0) then
      Inc(BubbleHeight, 8);

    BubbleWidth := BubbleMaxWidth;
    if Msg.Outgoing then
      LeftPos := SelectionOffset + DrawAreaWidth - BubbleWidth - SIDE_MARGIN
    else
      LeftPos := SIDE_MARGIN + SelectionOffset;

    FLayouts[I].Message := Msg;
    FLayouts[I].BubbleRect := Rect(LeftPos, CursorY, LeftPos + BubbleWidth, CursorY + BubbleHeight);

    QuoteBlockLeft := LeftPos + BUBBLE_PADDING_X;
    QuoteBlockTop := CursorY + BUBBLE_PADDING_Y;
    if QuoteHeight > 0 then
    begin
      FLayouts[I].QuoteRect := Rect(
        QuoteBlockLeft,
        QuoteBlockTop,
        LeftPos + BubbleWidth - BUBBLE_PADDING_X,
        QuoteBlockTop + QuoteHeight);
    end
    else
      FLayouts[I].QuoteRect := Rect(0, 0, 0, 0);

    TextTop := QuoteBlockTop + QuoteHeight + Ord(QuoteHeight > 0) * 8;
    if AttachmentBlockHeight > 0 then
    begin
      FLayouts[I].AttachmentRect := Rect(
        LeftPos + BUBBLE_PADDING_X,
        TextTop,
        LeftPos + BubbleWidth - BUBBLE_PADDING_X,
        TextTop + AttachmentBlockHeight);
      Inc(TextTop, AttachmentBlockHeight + Ord(TextHeight > 0) * 8);
    end
    else
      FLayouts[I].AttachmentRect := Rect(0, 0, 0, 0);

    if TextHeight > 0 then
      FLayouts[I].TextRect := Rect(
        LeftPos + BUBBLE_PADDING_X,
        TextTop,
        LeftPos + BubbleWidth - BUBBLE_PADDING_X,
        TextTop + TextHeight)
    else
      FLayouts[I].TextRect := Rect(0, 0, 0, 0);

    FLayouts[I].TimeRect := Rect(
      LeftPos + BubbleWidth - 64,
      CursorY + BubbleHeight - 22,
      LeftPos + BubbleWidth - 12,
      CursorY + BubbleHeight - 8);

    CursorY := CursorY + BubbleHeight + MESSAGE_GAP;
  end;

  UpdateScrollbar;
end;

function TMessengerChat.AttachmentHeight(AMessage: TMessengerMessage;
  ABubbleWidth: Integer): Integer;
begin
  Result := 0;
  if AMessage = nil then
    Exit;

  case AMessage.Kind of
    mmPhoto:
      Result := PHOTO_BLOCK_HEIGHT;
    mmFile:
      Result := FILE_BLOCK_HEIGHT;
  end;
end;

procedure TMessengerChat.ScrollbarChange(Sender: TObject);
begin
  if FUpdatingScrollbar then
    Exit;
  Invalidate;
end;

procedure TMessengerChat.SelectionCloseClick(Sender: TObject);
begin
  ClearSelection;
  LayoutChildren;
end;

procedure TMessengerChat.SelectionCopyClick(Sender: TObject);
begin
  CopySelectedMessages;
end;

procedure TMessengerChat.SelectionDeleteClick(Sender: TObject);
begin
  DeleteSelectedMessages;
end;

procedure TMessengerChat.SelectionEditClick(Sender: TObject);
begin
  if SelectedCount = 1 then
    BeginEditMessage(FSelectedMessage);
end;

procedure TMessengerChat.SendButtonClick(Sender: TObject);
var
  OutText: string;
  ReplySender: string;
  ReplyText: string;
begin
  OutText := Trim(FInput.Text);
  if OutText = '' then
    Exit;

  if SelectedCount > 0 then
    ClearSelection;

  if IsEditing then
  begin
    EditMessageText(FEditingMessage, OutText);
    FInput.Clear;
    CancelEdit;
    Exit;
  end;

  ReplySender := FCurrentReplySender;
  ReplyText := FCurrentReplyText;

  if Assigned(FOnSendMessage) then
    FOnSendMessage(Self, OutText, ReplySender, ReplyText);

  if FAutoAddOutgoing then
    AddOutgoing(OutText, FormatDateTime('hh:nn', Now), ReplySender, ReplyText);

  FInput.Clear;
  CancelReply;
end;

procedure TMessengerChat.SetBackgroundColor(AValue: TColor);
begin
  if FBackgroundColor = AValue then
    Exit;
  FBackgroundColor := AValue;
  Invalidate;
end;

procedure TMessengerChat.SetBubbleIncomingColor(AValue: TColor);
begin
  if FBubbleIncomingColor = AValue then
    Exit;
  FBubbleIncomingColor := AValue;
  Invalidate;
end;

procedure TMessengerChat.SetBubbleOutgoingColor(AValue: TColor);
begin
  if FBubbleOutgoingColor = AValue then
    Exit;
  FBubbleOutgoingColor := AValue;
  Invalidate;
end;

procedure TMessengerChat.SetComposerColor(AValue: TColor);
begin
  if FComposerColor = AValue then
    Exit;
  FComposerColor := AValue;
  Invalidate;
end;

procedure TMessengerChat.UpdateScrollbar;
var
  MaxPos: Integer;
  ViewHeight: Integer;
begin
  if FScrollbar = nil then
    Exit;

  ViewHeight := Height - ComposerHeight - GetSelectionBarHeight;
  MaxPos := Max(0, ContentHeight - ViewHeight);
  FUpdatingScrollbar := True;
  try
    if FScrollbar.Min <> 0 then
      FScrollbar.Min := 0;
    if FScrollbar.Max <> MaxPos then
      FScrollbar.Max := MaxPos;
    if FScrollbar.PageSize <> Max(1, ViewHeight) then
      FScrollbar.PageSize := Max(1, ViewHeight);
    if FScrollbar.Position > MaxPos then
      FScrollbar.Position := MaxPos;
  finally
    FUpdatingScrollbar := False;
  end;
end;

procedure TMessengerChat.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  ClickedAttachment: Boolean;
  HadSelectionMode: Boolean;
  LayoutIndex: Integer;
  Msg: TMessengerMessage;
  P: TPoint;
begin
  inherited MouseDown(Button, Shift, X, Y);
  HadSelectionMode := IsSelectionMode;
  FContextMessage := nil;
  if Y >= Height - ComposerHeight then
    Exit;

  P := Point(X, Y + FScrollbar.Position);
  LayoutIndex := FindLayoutIndexAt(P);
  if LayoutIndex >= 0 then
    Msg := FLayouts[LayoutIndex].Message
  else
    Msg := nil;
  ClickedAttachment := (LayoutIndex >= 0) and PtInRect(FLayouts[LayoutIndex].AttachmentRect, P);

  if Button = mbLeft then
  begin
    if Msg = nil then
      ClearSelection
    else if HadSelectionMode or HasShortcutModifier(Shift) then
      ToggleMessageSelection(Msg)
    else
      FSelectedMessage := Msg;

    if ClickedAttachment and (not HadSelectionMode) then
      OpenAttachment(Msg);
  end
  else if Button = mbRight then
  begin
    if Msg = nil then
    begin
      if not HadSelectionMode then
        FSelectedMessage := nil;
    end
    else
    begin
      FContextMessage := Msg;
      if not HadSelectionMode then
        FSelectedMessage := Msg;
    end;
  end;

  if Button = mbRight then
  begin
    FMenuSelectItem.Visible := (FContextMessage <> nil) and (not HadSelectionMode);
    FMenuSelectItem.Enabled := FContextMessage <> nil;
    FMenuCopyItem.Enabled := (SelectedCount > 0) or (FContextMessage <> nil);
    FMenuEditItem.Enabled := (SelectedCount = 1) or ((SelectedCount = 0) and (FContextMessage <> nil));
    FMenuDeleteItem.Enabled := (SelectedCount > 0) or (FContextMessage <> nil);
    if (SelectedCount > 0) or (FContextMessage <> nil) then
      FContextMenu.PopUp(ClientToScreen(Point(X, Y)).X, ClientToScreen(Point(X, Y)).Y);
  end;
  LayoutChildren;
  Invalidate;
end;

procedure TMessengerChat.HandleMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if WheelDelta < 0 then
    FScrollbar.Position := Min(FScrollbar.Max, FScrollbar.Position + SCROLL_STEP)
  else if WheelDelta > 0 then
    FScrollbar.Position := Max(FScrollbar.Min, FScrollbar.Position - SCROLL_STEP);
  Handled := True;
end;

procedure TMessengerChat.CreateWnd;
begin
  inherited CreateWnd;
  if not (csDesigning in ComponentState) then
    DragAcceptFiles(Handle, True);
end;

procedure TMessengerChat.DestroyWnd;
begin
  if HandleAllocated then
    DragAcceptFiles(Handle, False);
  inherited DestroyWnd;
end;

procedure TMessengerChat.WMDropFiles(var Message: TWMDropFiles);
var
  Count: UINT;
  I: UINT;
  Len: UINT;
  Buffer: TArray<Char>;
  FileNames: TMessengerFileNames;
begin
  try
    Count := DragQueryFile(Message.Drop, $FFFFFFFF, nil, 0);
    if Count = 0 then
      Exit;
    SetLength(FileNames, Count);
    for I := 0 to Count - 1 do
    begin
      Len := DragQueryFile(Message.Drop, I, nil, 0);
      SetLength(Buffer, Len + 1);
      if Len > 0 then
      begin
        DragQueryFile(Message.Drop, I, PChar(@Buffer[0]), Len + 1);
        SetString(FileNames[I], PChar(@Buffer[0]), Len);
      end
      else
        FileNames[I] := '';
    end;

    if Length(FileNames) > 0 then
    begin
      if Assigned(FOnDropFiles) then
        FOnDropFiles(Self, FileNames)
      else if Assigned(FOnAttachClick) then
        FOnAttachClick(Self);
    end;
  finally
    DragFinish(Message.Drop);
  end;
end;
procedure TMessengerChat.DblClick;
begin
  inherited DblClick;
  if Assigned(FOnMessageDblClick) and Assigned(FSelectedMessage) then
    FOnMessageDblClick(Self, FSelectedMessage);
end;

procedure TMessengerChat.Paint;
var
  I: Integer;
  OffsetY: Integer;
  ComposerTop: Integer;
  PreviewRect: TRect;
  PreviewSenderRect: TRect;
  PreviewTextRect: TRect;
  VisibleBubble: TRect;
begin
  Canvas.Brush.Color := FBackgroundColor;
  Canvas.FillRect(ClientRect);

  RebuildLayout;
  OffsetY := -FScrollbar.Position;

  for I := 0 to High(FLayouts) do
  begin
    VisibleBubble := FLayouts[I].BubbleRect;
    OffsetRect(VisibleBubble, 0, OffsetY);
    if (VisibleBubble.Bottom >= 0) and (VisibleBubble.Top <= Height - ComposerHeight) then
      DrawBubble(FLayouts[I]);
  end;

  ComposerTop := Height - ComposerHeight;
  Canvas.Brush.Color := FComposerColor;
  Canvas.Pen.Color := $00D9CFC2;
  Canvas.Rectangle(0, ComposerTop, Width, Height);

  if IsEditing or (FCurrentReplyText <> '') then
  begin
    PreviewRect := Rect(16, ComposerTop + 4, Width - 60, ComposerTop + 38);
    Canvas.Brush.Color := clWhite;
    Canvas.Pen.Style := psClear;
    Canvas.RoundRect(PreviewRect.Left, PreviewRect.Top, PreviewRect.Right, PreviewRect.Bottom, 8, 8);
    Canvas.Pen.Style := psSolid;
    if IsEditing then
      Canvas.Brush.Color := $00F5C16C
    else
      Canvas.Brush.Color := $008ED0F9;
    Canvas.FillRect(Rect(PreviewRect.Left + 8, PreviewRect.Top + 4, PreviewRect.Left + 12, PreviewRect.Bottom - 4));
    Canvas.Brush.Style := bsClear;
    Canvas.Font.Style := [fsBold];
    Canvas.Font.Color := clBlack;
    PreviewSenderRect := Rect(PreviewRect.Left + 18, PreviewRect.Top + 3,
      PreviewRect.Right - 10, PreviewRect.Top + 18);
    if IsEditing then
      DrawText(Canvas.Handle, PChar('Editing message'), Length('Editing message'),
        PreviewSenderRect, DT_LEFT or DT_NOPREFIX or DT_END_ELLIPSIS)
    else
      DrawText(Canvas.Handle, PChar(FCurrentReplySender), Length(FCurrentReplySender),
        PreviewSenderRect, DT_LEFT or DT_NOPREFIX or DT_END_ELLIPSIS);
    Canvas.Font.Style := [];
    Canvas.Font.Color := $00606060;
    PreviewTextRect := Rect(PreviewRect.Left + 18, PreviewRect.Top + 18,
      PreviewRect.Right - 10, PreviewRect.Bottom - 4);
    if IsEditing then
      DrawText(Canvas.Handle, PChar(GetMessagePreviewText(FEditingMessage)),
        Length(GetMessagePreviewText(FEditingMessage)), PreviewTextRect,
        DT_LEFT or DT_NOPREFIX or DT_END_ELLIPSIS)
    else
      DrawText(Canvas.Handle, PChar(FCurrentReplyText), Length(FCurrentReplyText),
        PreviewTextRect, DT_LEFT or DT_NOPREFIX or DT_END_ELLIPSIS);
    Canvas.Brush.Style := bsSolid;
  end;
end;

procedure TMessengerChat.Resize;
begin
  inherited Resize;
  LayoutChildren;
end;

function TMessengerChat.WrapTextHeight(const AText: string; AWidth: Integer): Integer;
var
  R: TRect;
begin
  R := Rect(0, 0, AWidth, 0);
  DrawText(Canvas.Handle, PChar(AText), Length(AText), R, DT_WORDBREAK or DT_CALCRECT or DT_LEFT or DT_NOPREFIX);
  Result := Max(18, RectHeight(R));
end;

procedure TMessengerChat.DrawBubble(const ALayout: TMessageLayout);
var
  AttachmentInfoRect: TRect;
  BubbleRect: TRect;
  CheckRect: TRect;
  DetailRect: TRect;
  DrawRect: TRect;
  ImageRect: TRect;
  QuoteRect: TRect;
  QuoteSenderRect: TRect;
  TextRect: TRect;
  TimeRect: TRect;
  QuoteTextRect: TRect;
  TextFlags: LongInt;
begin
  BubbleRect := ALayout.BubbleRect;
  QuoteRect := ALayout.QuoteRect;
  DrawRect := ALayout.AttachmentRect;
  TextRect := ALayout.TextRect;
  TimeRect := ALayout.TimeRect;

  OffsetRect(BubbleRect, 0, -FScrollbar.Position);
  OffsetRect(QuoteRect, 0, -FScrollbar.Position);
  OffsetRect(DrawRect, 0, -FScrollbar.Position);
  OffsetRect(TextRect, 0, -FScrollbar.Position);
  OffsetRect(TimeRect, 0, -FScrollbar.Position);

  Canvas.Pen.Style := psClear;
  if IsMessageSelected(ALayout.Message) then
    Canvas.Brush.Color := $00E8F3FF
  else if ALayout.Message.Outgoing then
    Canvas.Brush.Color := FBubbleOutgoingColor
  else
    Canvas.Brush.Color := FBubbleIncomingColor;
  Canvas.RoundRect(BubbleRect.Left, BubbleRect.Top, BubbleRect.Right, BubbleRect.Bottom, 14, 14);
  Canvas.Pen.Style := psSolid;
  Canvas.Pen.Color := $00D7D7D7;

  if IsSelectionMode then
  begin
    CheckRect := GetSelectionToggleRect(BubbleRect);
    Canvas.Brush.Color := clWhite;
    Canvas.Pen.Color := $0094AAC0;
    Canvas.Ellipse(CheckRect);
    if IsMessageSelected(ALayout.Message) then
    begin
      Canvas.Brush.Color := $008ED0F9;
      Canvas.Pen.Color := $008ED0F9;
      Canvas.Ellipse(CheckRect);
      Canvas.Brush.Style := bsClear;
      Canvas.Font.Color := clWhite;
      Canvas.Font.Style := [fsBold];
      Canvas.TextOut(CheckRect.Left + 4, CheckRect.Top + 1, '✓');
      Canvas.Font.Style := [];
      Canvas.Brush.Style := bsSolid;
      Canvas.Pen.Color := $00D7D7D7;
    end;
  end;

  if RectWidth(QuoteRect) > 0 then
  begin
    Canvas.Brush.Color := $008ED0F9;
    Canvas.FillRect(Rect(QuoteRect.Left, QuoteRect.Top, QuoteRect.Left + QUOTE_BAR_WIDTH, QuoteRect.Bottom));
    Canvas.Brush.Style := bsClear;
    Canvas.Font.Style := [fsBold];
    Canvas.Font.Color := clBlack;
    QuoteSenderRect := Rect(
      QuoteRect.Left + QUOTE_BAR_WIDTH + QUOTE_GAP,
      QuoteRect.Top,
      QuoteRect.Right,
      QuoteRect.Top + 16);
    DrawText(Canvas.Handle, PChar(ALayout.Message.QuoteSender), Length(ALayout.Message.QuoteSender),
      QuoteSenderRect, DT_LEFT or DT_NOPREFIX or DT_END_ELLIPSIS);
    Canvas.Font.Style := [];
    Canvas.Font.Color := $00606060;
    TextFlags := DT_WORDBREAK or DT_LEFT or DT_NOPREFIX;
    QuoteTextRect := Rect(
      QuoteRect.Left + QUOTE_BAR_WIDTH + QUOTE_GAP,
      QuoteRect.Top + 18,
      QuoteRect.Right,
      QuoteRect.Bottom);
    DrawText(Canvas.Handle, PChar(ALayout.Message.QuoteText), Length(ALayout.Message.QuoteText),
      QuoteTextRect, TextFlags);
    Canvas.Brush.Style := bsSolid;
  end;

  if RectWidth(DrawRect) > 0 then
  begin
    if ALayout.Message.Kind = mmPhoto then
    begin
      Canvas.Pen.Style := psClear;
      Canvas.Brush.Color := $00DDEAF5;
      Canvas.RoundRect(DrawRect.Left, DrawRect.Top, DrawRect.Right, DrawRect.Bottom, 10, 10);
      if not ALayout.Message.PreviewBitmap.Empty then
      begin
        Canvas.Pen.Style := psClear;
        Canvas.Brush.Color := clWhite;
        Canvas.RoundRect(DrawRect.Left + 1, DrawRect.Top + 1, DrawRect.Right - 1, DrawRect.Bottom - 1, 10, 10);
        ImageRect := FitRectIntoRect(
          Point(ALayout.Message.PreviewBitmap.Width, ALayout.Message.PreviewBitmap.Height),
          Rect(DrawRect.Left + 1, DrawRect.Top + 1, DrawRect.Right - 1, DrawRect.Bottom - 1)
        );
        Canvas.StretchDraw(ImageRect, ALayout.Message.PreviewBitmap);
      end
      else
      begin
        Canvas.Brush.Style := bsClear;
        Canvas.Font.Style := [fsBold];
        Canvas.Font.Color := $00495059;
        Canvas.TextOut(DrawRect.Left + 12, DrawRect.Top + 12, 'Photo');
        Canvas.Font.Style := [];
        if ALayout.Message.AttachmentName <> '' then
          Canvas.TextOut(DrawRect.Left + 12, DrawRect.Top + 34, ALayout.Message.AttachmentName);
        if ALayout.Message.AttachmentDetails <> '' then
        begin
          Canvas.Font.Color := $00666666;
          Canvas.TextOut(DrawRect.Left + 12, DrawRect.Top + 52, ALayout.Message.AttachmentDetails);
        end;
        Canvas.Brush.Style := bsSolid;
      end;
    end
    else if ALayout.Message.Kind = mmFile then
    begin
      Canvas.Pen.Style := psClear;
      Canvas.Brush.Color := $00EEF4FA;
      Canvas.RoundRect(DrawRect.Left, DrawRect.Top, DrawRect.Right, DrawRect.Bottom, 10, 10);
      Canvas.Brush.Color := $00B9D7F2;
      Canvas.RoundRect(DrawRect.Left + 10, DrawRect.Top + 10, DrawRect.Left + 42, DrawRect.Top + 42, 8, 8);
      Canvas.Brush.Style := bsClear;
      Canvas.Font.Style := [fsBold];
      Canvas.Font.Color := clBlack;
      AttachmentInfoRect := Rect(DrawRect.Left + 52, DrawRect.Top + 10, DrawRect.Right - 12, DrawRect.Top + 28);
      DrawText(Canvas.Handle, PChar(ALayout.Message.AttachmentName),
        Length(ALayout.Message.AttachmentName), AttachmentInfoRect, DT_LEFT or DT_NOPREFIX or DT_END_ELLIPSIS);
      Canvas.Font.Style := [];
      Canvas.Font.Color := $00666666;
      DetailRect := Rect(DrawRect.Left + 52, DrawRect.Top + 30, DrawRect.Right - 12, DrawRect.Bottom - 10);
      DrawText(Canvas.Handle, PChar(ALayout.Message.AttachmentDetails),
        Length(ALayout.Message.AttachmentDetails), DetailRect, DT_LEFT or DT_NOPREFIX or DT_END_ELLIPSIS);
      Canvas.Brush.Style := bsSolid;
    end;
  end;

  if RectWidth(TextRect) > 0 then
  begin
    Canvas.Brush.Style := bsClear;
    Canvas.Font.Style := [];
    Canvas.Font.Color := clBlack;
    TextFlags := DT_WORDBREAK or DT_LEFT or DT_NOPREFIX;
    DrawText(Canvas.Handle, PChar(ALayout.Message.Text), Length(ALayout.Message.Text), TextRect, TextFlags);
  end;

  Canvas.Font.Color := $00666666;
  Canvas.Font.Size := 8;
  Canvas.TextOut(TimeRect.Left, TimeRect.Top, ALayout.Message.TimeText);
  Canvas.Font.Size := 10;
  Canvas.Brush.Style := bsSolid;
end;

function TMessengerChat.AddIncoming(const ASender, AText, ATimeText: string;
  const AQuoteSender: string; const AQuoteText: string): TMessengerMessage;
begin
  Result := AddMessage(ASender, AText, ATimeText, False, AQuoteSender, AQuoteText);
end;

function TMessengerChat.AddIncomingFile(const ASender, AFileName, AFilePath,
  AFileSizeText, ATimeText: string; const ACaption: string;
  const AQuoteSender: string; const AQuoteText: string): TMessengerMessage;
begin
  Result := AddAttachmentMessage(ASender, ACaption, ATimeText, False, mmFile,
    AFileName, AFilePath, AFileSizeText, AQuoteSender, AQuoteText);
end;

function TMessengerChat.AddIncomingPhoto(const ASender, AFileName, AFilePath,
  ATimeText: string; const ACaption: string; const AQuoteSender: string;
  const AQuoteText: string): TMessengerMessage;
begin
  Result := AddAttachmentMessage(ASender, ACaption, ATimeText, False, mmPhoto,
    AFileName, AFilePath, '', AQuoteSender, AQuoteText);
end;

function TMessengerChat.AddOutgoing(const AText, ATimeText: string;
  const AQuoteSender: string; const AQuoteText: string): TMessengerMessage;
begin
  Result := AddMessage('You', AText, ATimeText, True, AQuoteSender, AQuoteText);
end;

function TMessengerChat.AddOutgoingFile(const AFileName, AFilePath,
  AFileSizeText, ATimeText: string; const ACaption: string;
  const AQuoteSender: string; const AQuoteText: string): TMessengerMessage;
begin
  Result := AddAttachmentMessage('You', ACaption, ATimeText, True, mmFile,
    AFileName, AFilePath, AFileSizeText, AQuoteSender, AQuoteText);
end;

function TMessengerChat.AddOutgoingPhoto(const AFileName, AFilePath,
  ATimeText: string; const ACaption: string; const AQuoteSender: string;
  const AQuoteText: string): TMessengerMessage;
begin
  Result := AddAttachmentMessage('You', ACaption, ATimeText, True, mmPhoto,
    AFileName, AFilePath, '', AQuoteSender, AQuoteText);
end;

function TMessengerChat.AddMessage(const ASender, AText, ATimeText: string;
  AOutgoing: Boolean; const AQuoteSender: string; const AQuoteText: string): TMessengerMessage;
begin
  Result := TMessengerMessage.Create;
  Result.ID := FNextID;
  Inc(FNextID);
  Result.Sender := ASender;
  Result.Text := AText;
  Result.TimeText := ATimeText;
  Result.Outgoing := AOutgoing;
  Result.QuoteSender := AQuoteSender;
  Result.QuoteText := AQuoteText;
  FMessages.Add(Result);
  RebuildLayout;
  ScrollToBottom;
  Invalidate;
end;

function TMessengerChat.AddAttachmentMessage(const ASender, AText, ATimeText: string;
  AOutgoing: Boolean; AKind: TMessengerMessageKind; const AAttachmentName,
  AAttachmentPath, AAttachmentDetails: string; const AQuoteSender: string;
  const AQuoteText: string): TMessengerMessage;
var
  LocalFileSize: Int64;
begin
  Result := TMessengerMessage.Create;
  Result.ID := FNextID;
  Inc(FNextID);
  Result.Kind := AKind;
  Result.Sender := ASender;
  Result.Text := AText;
  Result.TimeText := ATimeText;
  Result.Outgoing := AOutgoing;
  Result.QuoteSender := AQuoteSender;
  Result.QuoteText := AQuoteText;
  Result.AttachmentName := AAttachmentName;
  Result.AttachmentPath := AAttachmentPath;
  Result.AttachmentDetails := AAttachmentDetails;
  if AKind = mmPhoto then
    LoadPhotoPreview(Result, AAttachmentPath)
  else if (AAttachmentDetails = '') and TryGetFileSize(AAttachmentPath, LocalFileSize) then
    Result.AttachmentDetails := FormatByteSize(LocalFileSize);
  FMessages.Add(Result);
  RebuildLayout;
  ScrollToBottom;
  Invalidate;
end;

procedure TMessengerChat.BeginEditMessage(AMessage: TMessengerMessage);
begin
  if not Assigned(AMessage) then
    Exit;
  ClearSelection;
  CancelReply;
  FEditingMessage := AMessage;
  FInput.Text := AMessage.Text;
  FInput.SelStart := Length(FInput.Text);
  FocusInputIfPossible;
  LayoutChildren;
end;

procedure TMessengerChat.BeginReplyTo(AMessage: TMessengerMessage);
begin
  if not Assigned(AMessage) then
    Exit;
  ClearSelection;
  CancelEdit;
  FCurrentReplySender := AMessage.Sender;
  FCurrentReplyText := GetMessagePreviewText(AMessage);
  LayoutChildren;
end;

procedure TMessengerChat.CancelReply;
begin
  FCurrentReplySender := '';
  FCurrentReplyText := '';
  LayoutChildren;
end;

procedure TMessengerChat.CancelEdit;
begin
  if FEditingMessage <> nil then
    FInput.Clear;
  FEditingMessage := nil;
  LayoutChildren;
end;

procedure TMessengerChat.Clear;
begin
  FMessages.Clear;
  SetLength(FLayouts, 0);
  ClearSelection;
  FEditingMessage := nil;
  CancelReply;
  if FInput <> nil then
  begin
    FInput.SelStart := Length(FInput.Text);
    FocusInputIfPossible;
  end;
  Invalidate;
end;

procedure TMessengerChat.CopyMessageText(AMessage: TMessengerMessage);
begin
  if AMessage = nil then
    Exit;
  if AMessage.Text <> '' then
    Clipboard.AsText := AMessage.Text
  else if AMessage.AttachmentName <> '' then
    Clipboard.AsText := AMessage.AttachmentName
  else
    Clipboard.AsText := AMessage.AttachmentPath;
end;

procedure TMessengerChat.CopySelectedMessage;
begin
  if SelectedCount > 1 then
    CopySelectedMessages
  else if SelectedCount = 1 then
    CopyMessageText(FSelectedMessage)
  else
    CopyMessageText(FContextMessage);
end;

procedure TMessengerChat.CopySelectedMessages;
var
  I: Integer;
  Lines: TStringList;
  Msg: TMessengerMessage;
begin
  if SelectedCount = 0 then
    Exit;
  if SelectedCount = 1 then
  begin
    CopyMessageText(FSelectedMessage);
    Exit;
  end;

  Lines := TStringList.Create;
  try
    for I := 0 to FMessages.Count - 1 do
    begin
      Msg := TMessengerMessage(FMessages[I]);
      if IsMessageSelected(Msg) then
        Lines.Add(GetMessagePreviewText(Msg));
    end;
    Clipboard.AsText := TrimRight(Lines.Text);
  finally
    Lines.Free;
  end;
end;

procedure TMessengerChat.DeleteMessage(AMessage: TMessengerMessage);
var
  Index: Integer;
begin
  Index := IndexOfMessage(AMessage);
  if Index < 0 then
    Exit;

  if FEditingMessage = AMessage then
    CancelEdit;
  FSelectedMessages.Remove(AMessage);
  if FSelectedMessage = AMessage then
  begin
    if FSelectedMessages.Count > 0 then
      FSelectedMessage := TMessengerMessage(FSelectedMessages[FSelectedMessages.Count - 1])
    else
      FSelectedMessage := nil;
  end;

  FMessages.Delete(Index);
  UpdateActionButtons;
  RebuildLayout;
  Invalidate;
end;

procedure TMessengerChat.DeleteSelectedMessage;
begin
  if SelectedCount > 1 then
    DeleteSelectedMessages
  else if SelectedCount = 1 then
    DeleteMessage(FSelectedMessage)
  else
    DeleteMessage(FContextMessage);
end;

procedure TMessengerChat.DeleteSelectedMessages;
var
  I: Integer;
  EditedMessageWillBeDeleted: Boolean;
begin
  if SelectedCount = 0 then
    Exit;

  EditedMessageWillBeDeleted := (FEditingMessage <> nil) and IsMessageSelected(FEditingMessage);
  if EditedMessageWillBeDeleted then
    CancelEdit;

  for I := FMessages.Count - 1 downto 0 do
    if IsMessageSelected(TMessengerMessage(FMessages[I])) then
      FMessages.Delete(I);

  ClearSelection;
  RebuildLayout;
  Invalidate;
end;

procedure TMessengerChat.EditMessageText(AMessage: TMessengerMessage;
  const ANewText: string);
begin
  if AMessage = nil then
    Exit;
  AMessage.Text := ANewText;
  RebuildLayout;
  Invalidate;
end;

function TMessengerChat.HandleShortcut(var Key: Word; Shift: TShiftState): Boolean;
begin
  Result := False;

  if (Key = VK_ESCAPE) and (IsEditing or (FCurrentReplyText <> '')) then
  begin
    if IsEditing then
      CancelEdit
    else
      CancelReply;
    Key := 0;
    Exit(True);
  end;

  if (Key = VK_RETURN) and not (ssShift in Shift) and FInput.Focused then
  begin
    SendButtonClick(Self);
    Key := 0;
    Exit(True);
  end;

  if not HasShortcutModifier(Shift) then
  begin
    if ((Key = VK_DELETE) or (Key = VK_BACK)) and (not FInput.Focused)
      and (SelectedCount > 0) then
    begin
      DeleteSelectedMessages;
      Key := 0;
      Exit(True);
    end;
    Exit(False);
  end;

  case Key of
    Ord('C'):
      if SelectedCount > 0 then
      begin
        CopySelectedMessages;
        Key := 0;
        Exit(True);
      end;
    Ord('E'):
      if SelectedCount = 1 then
      begin
        BeginEditMessage(FSelectedMessage);
        Key := 0;
        Exit(True);
      end;
    VK_DELETE, VK_BACK:
      if SelectedCount > 0 then
      begin
        DeleteSelectedMessages;
        Key := 0;
        Exit(True);
      end;
  end;
end;

procedure TMessengerChat.InsertEmoji(const AEmoji: string);
begin
  FInput.SelText := AEmoji;
  FocusInputIfPossible;
end;

procedure TMessengerChat.ScrollToBottom;
begin
  RebuildLayout;
  FScrollbar.Position := FScrollbar.Max;
  Invalidate;
end;

procedure TMessengerChat.ToggleMessageSelection(AMessage: TMessengerMessage);
var
  Index: Integer;
begin
  if AMessage = nil then
    Exit;

  Index := FSelectedMessages.IndexOf(AMessage);
  if Index >= 0 then
  begin
    FSelectedMessages.Delete(Index);
    if FSelectedMessage = AMessage then
    begin
      if FSelectedMessages.Count > 0 then
        FSelectedMessage := TMessengerMessage(FSelectedMessages[FSelectedMessages.Count - 1])
      else
        FSelectedMessage := nil;
    end;
  end
  else
  begin
    FSelectedMessages.Add(AMessage);
    FSelectedMessage := AMessage;
  end;
  UpdateActionButtons;
end;

procedure TMessengerChat.UpdateActionButtons;
begin
  if FSelectionBar = nil then
    Exit;

  FSelectionBar.Visible := IsSelectionMode;
  if FSelectionInfoLabel <> nil then
  begin
    if SelectedCount = 1 then
      FSelectionInfoLabel.Caption := '1 selected'
    else
      FSelectionInfoLabel.Caption := IntToStr(SelectedCount) + ' selected';
  end;

  if FSelectionCopyButton <> nil then
    FSelectionCopyButton.Enabled := SelectedCount > 0;
  if FSelectionDeleteButton <> nil then
    FSelectionDeleteButton.Enabled := SelectedCount > 0;
  if FSelectionEditButton <> nil then
    FSelectionEditButton.Enabled := SelectedCount = 1;

  if FMenuCopyItem <> nil then
    FMenuCopyItem.Enabled := SelectedCount > 0;
  if FMenuDeleteItem <> nil then
    FMenuDeleteItem.Enabled := SelectedCount > 0;
  if FMenuEditItem <> nil then
    FMenuEditItem.Enabled := SelectedCount = 1;
  if FMenuSelectItem <> nil then
    FMenuSelectItem.Enabled := FContextMessage <> nil;
end;

end.










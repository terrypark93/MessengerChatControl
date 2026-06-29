object DemoForm: TDemoForm
  Left = 268
  Top = 127
  Caption = 'TMessengerChat Demo'
  ClientHeight = 790
  ClientWidth = 1220
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  TextHeight = 15
  object LeftPanel: TPanel
    Left = 0
    Top = 0
    Width = 290
    Height = 790
    Align = alLeft
    BevelOuter = bvNone
    Color = 15656408
    ParentBackground = False
    TabOrder = 0
    object TitleLabel: TLabel
      Left = 16
      Top = 18
      Width = 157
      Height = 28
      Caption = 'TMessengerChat'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LeftTextLabel: TLabel
      Left = 16
      Top = 52
      Width = 250
      Height = 68
      AutoSize = False
      Caption = 
        'This demo uses a guided chat conversation to explain text messag' +
        'es, replies, emoji, editing, multi-select, and real file attachm' +
        'ents.'
      WordWrap = True
    end
    object InstructionLabel: TLabel
      Left = 16
      Top = 720
      Width = 252
      Height = 46
      AutoSize = False
      Caption = 
        'Tips:'#13#10'1. Double-click a bubble to start a reply.'#13#10'2. Click a ph' +
        'oto or file bubble to open the real local attachment.'#13#10'3. Drag f' +
        'iles or photos onto the chat area to send them.'#13#10'4. Use Select p' +
        'lus the top selection bar for bulk actions.'
      WordWrap = True
    end
    object DemoButton: TButton
      Left = 16
      Top = 128
      Width = 258
      Height = 32
      Caption = 'Load Demo Conversation'
      TabOrder = 0
      OnClick = DemoButtonClick
    end
    object IncomingButton: TButton
      Left = 16
      Top = 168
      Width = 258
      Height = 32
      Caption = 'Add Incoming Message'
      TabOrder = 1
      OnClick = IncomingButtonClick
    end
    object OutgoingButton: TButton
      Left = 16
      Top = 208
      Width = 258
      Height = 32
      Caption = 'Add Outgoing Message'
      TabOrder = 2
      OnClick = OutgoingButtonClick
    end
    object AttachPhotoButton: TButton
      Left = 16
      Top = 248
      Width = 258
      Height = 32
      Caption = 'Attach Photo'
      TabOrder = 3
      OnClick = AttachPhotoButtonClick
    end
    object AttachFileButton: TButton
      Left = 16
      Top = 288
      Width = 258
      Height = 32
      Caption = 'Attach File'
      TabOrder = 4
      OnClick = AttachFileButtonClick
    end
    object ReplyButton: TButton
      Left = 16
      Top = 328
      Width = 258
      Height = 32
      Caption = 'Reply to Selected'
      TabOrder = 5
      OnClick = ReplyButtonClick
    end
    object ReplyCancelButton: TButton
      Left = 16
      Top = 368
      Width = 258
      Height = 32
      Caption = 'Cancel Reply'
      TabOrder = 6
      OnClick = ReplyCancelButtonClick
    end
    object EmojiButton: TButton
      Left = 16
      Top = 408
      Width = 258
      Height = 32
      Caption = 'Insert Emoji'
      TabOrder = 7
      OnClick = EmojiButtonClick
    end
    object ThemeButton: TButton
      Left = 16
      Top = 448
      Width = 258
      Height = 32
      Caption = 'Toggle Theme'
      TabOrder = 8
      OnClick = ThemeButtonClick
    end
    object ScrollButton: TButton
      Left = 16
      Top = 488
      Width = 258
      Height = 32
      Caption = 'Scroll to Bottom'
      TabOrder = 9
      OnClick = ScrollButtonClick
    end
    object ClearButton: TButton
      Left = 16
      Top = 528
      Width = 258
      Height = 32
      Caption = 'Clear Chat'
      TabOrder = 10
      OnClick = ClearButtonClick
    end
    object CopyButton: TButton
      Left = 16
      Top = 568
      Width = 258
      Height = 32
      Caption = 'Copy Selected'
      TabOrder = 11
      OnClick = CopyButtonClick
    end
    object EditButton: TButton
      Left = 16
      Top = 608
      Width = 258
      Height = 32
      Caption = 'Edit Selected'
      TabOrder = 12
      OnClick = EditButtonClick
    end
    object DeleteButton: TButton
      Left = 16
      Top = 648
      Width = 258
      Height = 32
      Caption = 'Delete Selected'
      TabOrder = 13
      OnClick = DeleteButtonClick
    end
    object AutoSendCheck: TCheckBox
      Left = 18
      Top = 696
      Width = 241
      Height = 18
      Caption = 'Automatically add outgoing messages'
      TabOrder = 14
      OnClick = AutoSendCheckChange
    end
  end
  object RightPanel: TPanel
    Left = 930
    Top = 0
    Width = 290
    Height = 790
    Align = alRight
    BevelOuter = bvNone
    Color = 16249578
    ParentBackground = False
    TabOrder = 1
    DesignSize = (
      290
      790)
    object LogTitleLabel: TLabel
      Left = 16
      Top = 16
      Width = 79
      Height = 23
      Caption = 'Event Log'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object EventLog: TMemo
      Left = 16
      Top = 48
      Width = 258
      Height = 734
      Anchors = [akLeft, akTop, akRight, akBottom]
      BorderStyle = bsNone
      Color = 16711161
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object Messenger: TMessengerChat
    Left = 290
    Top = 0
    Width = 640
    Height = 790
    Align = alClient
    BackgroundColor = 16118250
    Color = clWhite
    ParentColor = False
    TabOrder = 2
    DesignSize = (
      640
      790)
  end
  object EmojiBar: TPanel
    Left = 452
    Top = 92
    Width = 246
    Height = 44
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 3
    Visible = False
    object EmojiBarSmileButton: TSpeedButton
      Left = 10
      Top = 8
      Width = 28
      Height = 28
      Caption = #55357#56898
      Flat = True
      OnClick = EmojiItemClick
    end
    object EmojiBarFireButton: TSpeedButton
      Left = 48
      Top = 8
      Width = 28
      Height = 28
      Caption = #55357#56613
      Flat = True
      OnClick = EmojiItemClick
    end
    object EmojiBarThumbsUpButton: TSpeedButton
      Left = 86
      Top = 8
      Width = 28
      Height = 28
      Caption = #55357#56397
      Flat = True
      OnClick = EmojiItemClick
    end
    object EmojiBarClapButton: TSpeedButton
      Left = 124
      Top = 8
      Width = 28
      Height = 28
      Caption = #55356#57225
      Flat = True
      OnClick = EmojiItemClick
    end
    object EmojiBarLaughButton: TSpeedButton
      Left = 162
      Top = 8
      Width = 28
      Height = 28
      Caption = #55357#56834
      Flat = True
      OnClick = EmojiItemClick
    end
    object EmojiBarWaveButton: TSpeedButton
      Left = 200
      Top = 8
      Width = 28
      Height = 28
      Caption = #55358#56605
      Flat = True
      OnClick = EmojiItemClick
    end
  end
  object AutoReplyTimer: TTimer
    Enabled = False
    Interval = 900
    OnTimer = AutoReplyTimerTimer
    Left = 1056
    Top = 120
  end
  object AttachMenu: TPopupMenu
    Left = 1060
    Top = 216
    object AttachMenuPhotoItem: TMenuItem
      Caption = 'Photo'
      OnClick = AttachMenuPhotoItemClick
    end
    object AttachMenuFileItem: TMenuItem
      Caption = 'File'
      OnClick = AttachMenuFileItemClick
    end
  end
end

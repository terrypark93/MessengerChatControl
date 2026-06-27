object DemoForm: TDemoForm
  Left = 268
  Height = 790
  Top = 127
  Width = 1220
  Caption = 'TMessengerChat Demo'
  ClientHeight = 790
  ClientWidth = 1220
  KeyPreview = True
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  object LeftPanel: TPanel
    Left = 0
    Height = 790
    Top = 0
    Width = 290
    Align = alLeft
    BevelOuter = bvNone
    Color = 15656408
    ParentBackground = False
    ParentColor = False
    TabOrder = 0
    object TitleLabel: TLabel
      Left = 16
      Height = 23
      Top = 18
      Width = 162
      Caption = 'TMessengerChat'
      Font.Height = -20
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LeftTextLabel: TLabel
      Left = 16
      Height = 68
      Top = 52
      Width = 250
      AutoSize = False
      Caption = 'This demo uses a guided chat conversation to explain text messages, replies, emoji, editing, multi-select, and real file attachments.'
      WordWrap = True
    end
    object DemoButton: TButton
      Left = 16
      Height = 32
      Top = 128
      Width = 258
      Caption = 'Load Demo Conversation'
      TabOrder = 0
      OnClick = DemoButtonClick
    end
    object IncomingButton: TButton
      Left = 16
      Height = 32
      Top = 168
      Width = 258
      Caption = 'Add Incoming Message'
      TabOrder = 1
      OnClick = IncomingButtonClick
    end
    object OutgoingButton: TButton
      Left = 16
      Height = 32
      Top = 208
      Width = 258
      Caption = 'Add Outgoing Message'
      TabOrder = 2
      OnClick = OutgoingButtonClick
    end
    object AttachPhotoButton: TButton
      Left = 16
      Height = 32
      Top = 248
      Width = 258
      Caption = 'Attach Photo'
      TabOrder = 3
      OnClick = AttachPhotoButtonClick
    end
    object AttachFileButton: TButton
      Left = 16
      Height = 32
      Top = 288
      Width = 258
      Caption = 'Attach File'
      TabOrder = 4
      OnClick = AttachFileButtonClick
    end
    object ReplyButton: TButton
      Left = 16
      Height = 32
      Top = 328
      Width = 258
      Caption = 'Reply to Selected'
      TabOrder = 5
      OnClick = ReplyButtonClick
    end
    object ReplyCancelButton: TButton
      Left = 16
      Height = 32
      Top = 368
      Width = 258
      Caption = 'Cancel Reply'
      TabOrder = 6
      OnClick = ReplyCancelButtonClick
    end
    object EmojiButton: TButton
      Left = 16
      Height = 32
      Top = 408
      Width = 258
      Caption = 'Insert Emoji'
      TabOrder = 7
      OnClick = EmojiButtonClick
    end
    object ThemeButton: TButton
      Left = 16
      Height = 32
      Top = 448
      Width = 258
      Caption = 'Toggle Theme'
      TabOrder = 8
      OnClick = ThemeButtonClick
    end
    object ScrollButton: TButton
      Left = 16
      Height = 32
      Top = 488
      Width = 258
      Caption = 'Scroll to Bottom'
      TabOrder = 9
      OnClick = ScrollButtonClick
    end
    object ClearButton: TButton
      Left = 16
      Height = 32
      Top = 528
      Width = 258
      Caption = 'Clear Chat'
      TabOrder = 10
      OnClick = ClearButtonClick
    end
    object CopyButton: TButton
      Left = 16
      Height = 32
      Top = 568
      Width = 258
      Caption = 'Copy Selected'
      TabOrder = 11
      OnClick = CopyButtonClick
    end
    object EditButton: TButton
      Left = 16
      Height = 32
      Top = 608
      Width = 258
      Caption = 'Edit Selected'
      TabOrder = 12
      OnClick = EditButtonClick
    end
    object DeleteButton: TButton
      Left = 16
      Height = 32
      Top = 648
      Width = 258
      Caption = 'Delete Selected'
      TabOrder = 13
      OnClick = DeleteButtonClick
    end
    object AutoSendCheck: TCheckBox
      Left = 18
      Height = 18
      Top = 696
      Width = 241
      Caption = 'Automatically add outgoing messages'
      TabOrder = 14
      OnClick = AutoSendCheckChange
    end
    object InstructionLabel: TLabel
      Left = 16
      Height = 46
      Top = 720
      Width = 252
      AutoSize = False
      Caption = 'Tips:'#13#10'1. Double-click a bubble to start a reply.'#13#10'2. Click a photo or file bubble to open the real local attachment.'#13#10'3. Drag files or photos onto the chat area to send them.'#13#10'4. Use Select plus the top selection bar for bulk actions.'
      WordWrap = True
    end
  end
  object RightPanel: TPanel
    Left = 930
    Height = 790
    Top = 0
    Width = 290
    Align = alRight
    BevelOuter = bvNone
    Color = 16249578
    ParentBackground = False
    ParentColor = False
    TabOrder = 1
    object LogTitleLabel: TLabel
      Left = 16
      Height = 20
      Top = 16
      Width = 80
      Caption = 'Event Log'
      Font.Height = -17
      Font.Style = [fsBold]
      ParentFont = False
    end
    object EventLog: TMemo
      Left = 16
      Height = 734
      Top = 48
      Width = 258
      Anchors = [akTop, akLeft, akRight, akBottom]
      BorderStyle = bsNone
      Color = 16711161
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object Messenger: TMessengerChat
    Left = 290
    Height = 790
    Top = 0
    Width = 640
    Align = alClient
    BackgroundColor = 16118250
    Color = clWhite
    ParentColor = False
    TabOrder = 2
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
  object EmojiBar: TPanel
    Left = 452
    Height = 44
    Top = 92
    Width = 246
    BevelOuter = bvNone
    Color = 16777215
    ParentBackground = False
    ParentColor = False
    TabOrder = 3
    Visible = False
    object EmojiBarSmileButton: TSpeedButton
      Left = 10
      Height = 28
      Top = 8
      Width = 28
      Caption = '🙂'
      Flat = True
      OnClick = EmojiItemClick
    end
    object EmojiBarFireButton: TSpeedButton
      Left = 48
      Height = 28
      Top = 8
      Width = 28
      Caption = '🔥'
      Flat = True
      OnClick = EmojiItemClick
    end
    object EmojiBarThumbsUpButton: TSpeedButton
      Left = 86
      Height = 28
      Top = 8
      Width = 28
      Caption = '👍'
      Flat = True
      OnClick = EmojiItemClick
    end
    object EmojiBarClapButton: TSpeedButton
      Left = 124
      Height = 28
      Top = 8
      Width = 28
      Caption = '🎉'
      Flat = True
      OnClick = EmojiItemClick
    end
    object EmojiBarLaughButton: TSpeedButton
      Left = 162
      Height = 28
      Top = 8
      Width = 28
      Caption = '😂'
      Flat = True
      OnClick = EmojiItemClick
    end
    object EmojiBarWaveButton: TSpeedButton
      Left = 200
      Height = 28
      Top = 8
      Width = 28
      Caption = '🤝'
      Flat = True
      OnClick = EmojiItemClick
    end
  end
end


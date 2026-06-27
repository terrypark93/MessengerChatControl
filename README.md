# TMessenger

**TMessenger** is a Delphi VCL component that provides a modern messenger-style chat interface for desktop applications.

https://github.com/WAYFARER87/TMessenger#tmessenger

Originally developed for Lazarus, this project has been **ported to Delphi 12** while preserving the original functionality and improving compatibility with modern Delphi VCL applications.

The component is designed for real-world applications rather than static mockups. It provides reusable APIs for chat messages, replies, editing, attachments, drag & drop, bulk selection, and emoji integration.

English | 한국어

---

## Screenshot

![Screenshot](screenshot.png)

---

# Features

### Modern messenger interface

* Incoming and outgoing chat bubbles
* Timestamp display
* Sender information
* Auto layout and scrolling

### Message management

* Reply preview
* Quoted messages
* Edit existing messages
* Delete individual messages
* Bulk delete
* Bulk copy

### Attachments

* Image attachments
* File attachments
* Click-to-open files
* Drag & Drop file support

### Emoji support

* Custom emoji picker
* Emoji insertion
* Host application controls emoji UI

### Designed for integration

The component exposes standard Delphi events, making it easy to connect to your own backend (TCP, WebSocket, REST, SignalR, etc.).

No networking code is included.

---

# Quick Start

Drop **TMessengerChat** onto a VCL form.

```delphi
procedure TMainForm.FormCreate(Sender: TObject);
begin
  MessengerChat1.AddIncoming(
    'Anton',
    'Hello',
    '10:12'
  );

  MessengerChat1.AddOutgoing(
    'Hi there',
    '10:13'
  );
end;
```

Reply example:

```delphi
procedure TMainForm.MessengerChat1MessageDblClick(
  Sender: TObject;
  AMessage: TMessengerMessage);
begin
  MessengerChat1.BeginReplyTo(AMessage);
end;
```

Send message:

```delphi
procedure TMainForm.MessengerChat1SendMessage(
  Sender: TObject;
  const AText,
        AReplySender,
        AReplyText: string);
begin
  MessengerChat1.AddOutgoing(
    AText,
    FormatDateTime('hh:nn', Now),
    AReplySender,
    AReplyText
  );
end;
```

---

# Main API

## Add messages

* AddIncoming
* AddOutgoing
* AddIncomingPhoto
* AddOutgoingPhoto
* AddIncomingFile
* AddOutgoingFile

## Message actions

* BeginReplyTo
* BeginEditMessage
* EditMessageText
* DeleteMessage
* DeleteSelectedMessages
* CopySelectedMessages
* Clear

## Useful properties

* InputMemo
* SelectedMessage
* SelectedCount

## Events

* OnSendMessage
* OnEmojiClick
* OnMessageDblClick
* OnAttachClick
* OnDropFiles

---

# Demo

## Chat Demo

Demonstrates:

* Reply
* Edit
* Delete
* Multi-selection
* Emoji
* Attachments
* Image preview
* Drag & Drop
* Theme switching

---

## Telegram Bot Demo

Includes a complete sample showing how to integrate the component with the Telegram Bot API.

Features:

* Long polling
* sendMessage
* getUpdates
* Two-way chat UI

---

# Project Structure

```text
TMessenger
│
├── Source
│   ├── Messenger.Chat.pas
│   ├── Messenger.Message.pas
│   └── ...
│
├── Demo
│
├── TelegramDemo
│
├── Images
│
├── docs
│   └── screenshot.png
│
├── README.md
└── LICENSE
```

---

# Requirements

* Delphi 12 or later
* Windows 10/11
* VCL

---

# Roadmap

Planned improvements include:

* Virtualized message rendering
* Built-in emoji picker
* Animated GIF support
* Sticker support
* Message search
* Markdown / Rich Text rendering
* Better high-DPI support

---

# License

MIT License

See the **LICENSE** file for details.

---

# Credits

Original Lazarus implementation by **Anton Lindeberg**

Delphi 12 port and maintenance by **Terry Park**

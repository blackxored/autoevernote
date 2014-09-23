require 'oauth'
require 'evernote_oauth'

module AutoEvernote
  class Evernote
    attr_reader   :client
    attr_accessor :default_notebook

    def initialize
      @client = EvernoteOAuth::Client.new(
        token: AutoEvernote.configuration.evernote.token,
        sandbox: false
      )
      @default_notebook = AutoEvernote.configuration.evernote.default_notebook
    end

    def store
      @store ||= @client.note_store
    end

    def notebooks
      @notebooks ||= store.listNotebooks
    end

    def create_note(title, body, notebook=default_notebook, tags=[])
      note = ::Evernote::EDAM::Type::Note.new
      note.title = title
      note.content = create_note_body(body)
      note.tagNames = (['autoevernote'] + tags).uniq

      if notebook
        note.notebookGuid = notebook.is_a?(String) ? find_notebook_guid(notebook) : notebook.guid
      end

      store_note(note)
    end

    def find_notebook_guid(name)
      notebooks.select { |n| n.name == name }.first.guid
    end

    def create_note_from_hash(hash)
      notebook = hash[:notebook] || default_notebook
      tags = hash[:tags] || []
      create_note(hash[:title], hash[:body], notebook, tags)
    end

    private
    def create_note_body(body)
      %Q{<?xml version="1.0" encoding="UTF-8"?>
         <!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
         <en-note>#{body}</en-note>
      }
    end

    def store_note(note)
      begin
        store.createNote(note)
      rescue ::Evernote::EDAM::Error::EDAMUserException => e
        puts "EDAM user exception: #{e.inspect}"
      rescue ::Evernote::EDAM::Error::EDAMNotFoundException => e
        puts "EDAM not found exception: #{e.inspect}"
      end
    end
  end
end

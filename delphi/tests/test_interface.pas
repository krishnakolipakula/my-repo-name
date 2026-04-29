Printable = interface
begin
  procedure display();
end

Message = class(Printable)
begin
  public var text: integer;
  
  constructor(value: integer)
  begin
    text := value;
  end
  
  procedure display()
  begin
    writeln(text);
  end
  
  destructor()
  begin
    writeln(0);
  end
end

var msg: Message;

msg := Message.Create(100);
msg.display();

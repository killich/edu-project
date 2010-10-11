#Paperclip.options[:command_path] = "/usr/local/bin"
#tom:~ tom$ export MAGICK_HOME="/opt/local/"
#tom:~ tom$ export PATH="$MAGICK_HOME/bin:$PATH"
#tom:~ tom$ export DYLD_LIBRARY_PATH="$MAGICK_HOME/lib"
#/usr/local/ImageMagick-6.4.8
#which convert
#FREE BSD /usr/local/bin/convert
#Ubuntu Paperclip.options[:command_path] = "/usr/bin/"
#Paperclip.options[:command_path] = '/usr/local/bin/'
#sudo apt-get install imagemagick ?

module Paperclip
  module Interpolations
    # Дополнения, позволяющие в путь сохранения изображений
    # добавлять новые теги
    
    # :url => '/uploads/:attachment/:login/:style.jpg'
    def login attachment, style
      attachment.instance.login
    end
    
    def holder_login attachment, style
      attachment.instance.user.login
    end

    # :url => '/uploads/:attachment/:zip/:style.jpg'
    def zip attachment, style
      attachment.instance.zip
    end
  end
end

Paperclip::Attachment.class_eval do
  def post_process_styles_with_validation
    return unless instance.need_thumb? rescue nil
    post_process_styles_without_validation
  end
  alias_method_chain :post_process_styles, :validation
end

#--
# Copyright (c) 2010 Ryan Grove <ryan@wonko.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the 'Software'), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#++
module SatitizeRules  
  module Config
    #SatitizeRules::Config::CLEAR
    TITLE = {
      :elements => ['span'],
      :attributes => {
        'span' => ['class'],
      }
    }
      
    #SatitizeRules::Config::CONTENT
    CONTENT = {
      :elements => ['h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'div', 'span', 'p', 'br', 'img', 'a', 'ol', 'ul', 'li', 'strong', 'b', 'em', 'i'],
      :attributes => {
        'a'          => ['href', 'title', 'name'],
        'img'        => ['align', 'alt', 'height', 'src', 'title', 'width'],
        'span'       => ['style'],
        'p'       => ['style', 'class'],
        'h1'       => ['style'],
        'h2'       => ['style'],
        'h3'       => ['style'],
        'h4'       => ['style'],
        'h5'       => ['style'],
        'h6'       => ['style']
      }
    }
    
    #SatitizeRules::Config::STRONG_CONTENT
    STRONG_CONTENT = {
      :elements => ['br', 'span', 'p', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'img', 'a'],
      :attributes => {
        'a'          => ['href', 'title'],
        'img'        => ['align', 'alt', 'height', 'src', 'title', 'width'],
      }
    }
  end
end

=begin
    EXAMPLE = {
      :elements => ['span'],
      :attributes=>{'span' => ['class']}

      
      :elements => [
        'a', 'b', 'blockquote', 'br', 'caption', 'cite', 'code', 'col',
        'colgroup', 'dd', 'dl', 'dt', 'em', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6',
        'i', 'img', 'li', 'ol', 'p', 'pre', 'q', 'small', 'strike', 'strong',
        'sub', 'sup', 'table', 'tbody', 'td', 'tfoot', 'th', 'thead', 'tr', 'u',
        'ul'],

      :attributes => {
        'a'          => ['href', 'title'],
        'blockquote' => ['cite'],
        'col'        => ['span', 'width'],
        'colgroup'   => ['span', 'width'],
        'img'        => ['align', 'alt', 'height', 'src', 'title', 'width'],
        'ol'         => ['start', 'type'],
        'q'          => ['cite'],
        'table'      => ['summary', 'width'],
        'td'         => ['abbr', 'axis', 'colspan', 'rowspan', 'width'],
        'th'         => ['abbr', 'axis', 'colspan', 'rowspan', 'scope',
                         'width'],
        'ul'         => ['type']
      },

      :protocols => {
        'a'          => {'href' => ['ftp', 'http', 'https', 'mailto',
                                    :relative]},
        'blockquote' => {'cite' => ['http', 'https', :relative]},
        'img'        => {'src'  => ['http', 'https', :relative]},
        'q'          => {'cite' => ['http', 'https', :relative]}
      }
    }
=end
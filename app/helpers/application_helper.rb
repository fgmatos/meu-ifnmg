module ApplicationHelper
  
  # show SVG embedded files
  def embedded_svg filename, options={}
    file = File.read(Rails.root.join('app', 'assets', 'images', filename))
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css 'svg'
    if options[:class].present?
      svg['class'] = options[:class]
    end
    doc.to_html.html_safe
  end
  
  # return a span tag with bootstrap glyphicon image
  def icon(name, css_class = nil)
    content_tag(:span,"", :class => "glyphicon glyphicon-#{name} #{css_class}")
  end
  
  def n(number, options=nil)
    
    default = {separator: ",", delimiter: ".", unit: ""}
    
    if (!options.nil?)
      default.merge!(options)          
    end

    number_to_currency(number, default) 
  end
  
end

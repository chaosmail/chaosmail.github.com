module Jekyll
  class CategoryListTag < Liquid::Tag
    def render(context)
      html = ""
      categories = context.registers[:site].categories.keys
      categories.sort.each do |category|
        posts_in_category = context.registers[:site].categories[category].size
        html << "<a class='page-link' href='/categories/#{category}/'>#{category.capitalize}</a>"
      end
      html
    end
  end
end
 
Liquid::Template.register_tag('category_list', Jekyll::CategoryListTag)

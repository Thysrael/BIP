module ApplicationHelper
  def hidden_div_if(condition, attributes={}, &block)
    # 将 html 中具有 attributes 并满足 condition 条件的 div 设置为 display: none
    if condition
      attributes["style"] = "display: none"
    end
    content_tag("div", attributes, &block)
  end
end

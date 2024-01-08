module ApplicationHelper
  # 改行をそのまま表示する
  # text: 表示したいテキスト
  def show_raw_text(text)
    if !text.is_a?(String)
      return text
    end
    return safe_join(text.split("\n"), tag(:br))
  end

  # 高度truncated
  # text: truncatedを行うテキスト (show_raw_textを使用する前のテキスト)
  # length: テキストの表示する長さ
  # maxline: デフォルト値 = 1, 複数行あるテキストの表示する最大行数
  def advanced_truncated(text, length, maxline = 1, omission = '...')
    if !text.is_a?(String)
      return text
    end
    splitted_texts = text.split("\n")
    # lengthを超える長さの行が無いか調べる
    overlength_line_index = -1
    for i in 0..(splitted_texts.count - 1)
      if splitted_texts[i].rstrip.length > length
        overlength_line_index = i
        break
      end
    end
    # 有効な最大行を求める
    available_line_count = splitted_texts.count
    if overlength_line_index > -1
      available_line_count = overlength_line_index + 1
    end

    result = []
    result_line_count = [available_line_count, maxline].min
    for i in 0..(result_line_count - 1)
      if i == overlength_line_index
        result[i] = splitted_texts[i].truncate(length, omission: '')
      else
        result[i] = splitted_texts[i]
      end
    end

    if maxline < available_line_count
      result[result_line_count] = omission
    elsif overlength_line_index > -1
      result[result_line_count - 1] += omission
    end

    return safe_join(result, tag(:br))

    # splitted_texts[i] = splitted_texts[i].truncate(length, omission: '') + '...'

    if overlength_line_index == -1
      result_line_count = [splitted_texts.count, maxline].min
      for i in result_line_count
        result[i] = splitted_texts[i]
      end
      if result_line_count < splitted_texts.count
        result[result_line_count] = "..."
      end

      #if splitted_texts.count < maxline
      #  for i in 0..(maxline - 1)
      #    result[i] = splitted_texts[i]
      #  end
      #  result[maxline] = "..."
      #  return safe_join(result, tag(:br))
      #else
      #  for i in 0..(splitted_texts.count - 1)
      #    result[i] = splitted_texts[i]
      #  end
      #  return safe_join(result, tag(:br))
      #end
    else
      if (overlength_line_index + 1) < maxline
        for i in 0..(maxline - 1)
          result[i] = splitted_texts[i]
        end
        result[maxline] = "..."
        return safe_join(result, tag(:br))
      else
        for i in 0..(overlength_line_index)
          if i == overlength_line_index
            result[i] = splitted_texts[i].truncate(length, omission: '')
          else
            result[i] = splitted_texts[i]
          end
        end
        result[overlength_line_index] = "..."
        return safe_join(result, tag(:br))
      end
    end
  end
end

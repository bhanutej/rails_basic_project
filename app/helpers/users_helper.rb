# UsersHelper
module UsersHelper
  def sorting_class(key)
    return 'fa-sort', 'asc' unless key == @sort_by
    if @sort_order == 'desc'
      return 'fa-sort-desc', 'asc'
    else
      return 'fa-sort-asc', 'desc'
    end
  end
end

require_relative 'test_helper.rb'
require 'nanotest'

include Nanotest

buy_toilet_papper = Liucheng.new('小田', '手纸没了。得买了', '小曹', '老吴', '徐总' ,'彭燕' ,'常社')

buy_book = Liucheng.new('小田', '工作中用到X想看书学学', '老吴', '徐总')

# 看看初始化实例是否正常
assert { buy_toilet_papper.user == '小田' }
assert { buy_toilet_papper.msg == '手纸没了。得买了' }
assert { buy_toilet_papper.states.to_a == %w(小曹 老吴 徐总 彭燕 常社)}
assert { buy_toilet_papper.undecided ==  %w(小曹 老吴 徐总 彭燕 常社) }
assert { buy_toilet_papper.approved == [] }
assert { buy_toilet_papper.status == nil }
assert { buy_toilet_papper.whose_turn == '小曹' }
assert { buy_book.reject_msg == [] }


assert { buy_book.user == '小田' }
assert { buy_book.msg == '工作中用到X想看书学学' }
assert { buy_book.states.to_a == %w(老吴 徐总)}
assert { buy_book.undecided ==  %w(老吴 徐总) }
assert { buy_book.approved == [] }
assert { buy_book.status == nil }
assert { buy_book.whose_turn == '老吴' }
assert { buy_book.reject_msg == [] }

# 走走流程
buy_toilet_papper.approve # 1
assert { buy_toilet_papper.undecided ==  %w(老吴 徐总 彭燕 常社) }
assert { buy_toilet_papper.approved == ['小曹'] }
# p buy_toilet_papper.done
assert { buy_toilet_papper.status == nil }
assert { buy_toilet_papper.whose_turn == '老吴' }
assert { buy_book.reject_msg == [] }

# 又有两个领导通过了
buy_toilet_papper.approve # 2
buy_toilet_papper.approve # 3
buy_toilet_papper.approve # 4
assert { buy_toilet_papper.undecided ==  %w(常社) }
assert { buy_toilet_papper.approved == %w(小曹 老吴 徐总 彭燕) }
assert { buy_toilet_papper.status == nil }
# p buy_toilet_papper.whose_turn
assert { buy_toilet_papper.whose_turn == '常社' }
assert { buy_book.reject_msg == [] }

# 最后一个领导通过了。检查先运行current不会抛异常
buy_toilet_papper.approve # 5
assert { buy_toilet_papper.undecided ==  [] }
assert { buy_toilet_papper.approved == %w(小曹 老吴 徐总 彭燕 常社) }
assert { buy_toilet_papper.status == true }
assert { buy_toilet_papper.whose_turn == nil }
assert { buy_book.reject_msg == [] }

# 看看拒绝的流程
buy_book.reject '多用java少瞎折腾'
# 上来老吴就拒绝了
assert { buy_book.whose_turn = '老吴'}
assert { buy_book.reject_msg == ['老吴' , '多用java少瞎折腾'] }

# 重置该请求
buy_book.reset
# 那么信息应该和上一次创建的时候一样
assert { buy_book.user == '小田' }
assert { buy_book.msg == '工作中用到X想看书学学' }
assert { buy_book.states.to_a == %w(老吴 徐总)}
assert { buy_book.undecided ==  %w(老吴 徐总) }
assert { buy_book.approved == [] }
assert { buy_book.status == nil }
assert { buy_book.whose_turn == '老吴' }
assert { buy_book.reject_msg == [] }

# 再来一次，这回拒绝不附加信息用默认的
# 由第二位审批的领导拒绝
buy_book.approve
buy_book.reject
assert { buy_book.reject_msg == ['徐总' , '我根本不care'] }





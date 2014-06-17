# ## 公文流程类
class Liucheng
  include Enumerable

  attr_reader :user, :msg, :states, :undecided, :approved, :status, :reject_msg
  attr_accessor :whose_turn
  def initialize(user, msg, *liucheng)
    @user = user
    @msg = msg
    @states = liucheng.to_enum.freeze
    @undecided = @states.dup.to_a # enumerator是无法用size, shift, join等命令的
    @approved = []
    @status = nil
    @whose_turn = @undecided.first
    @reject_msg = []
  end

  def reset
    @states.rewind
    @undecided = @states.dup.to_a # enumerator是无法用size, shift, join等命令的
    @approved = []
    @status = nil
    @whose_turn = @undecided.first
    @reject_msg = []
  end

  def approve
    if all_approved?
      false
    else
      @approved << @states.next
      @undecided.shift
      if @undecided.empty?
        @status, @whose_turn = true, nil
      else
        @whose_turn = @undecided.first
      end
    end
  end

  def all_approved?
    @status == true
  end

  def rejected?
    @status == :rejected
  end

  def reject(msg = '我根本不care')
    @reject_msg << @whose_turn << msg
    @status = :rejected
  end

  def show_waiting
    "就你这点儿屁事，牵动了#{@states.to_a.join(' ')}这些领导的心。\n"
  end

  def show_reject
    who, msg = @reject_msg
    "#{who}说：#{msg}"
  end

  def show_succeed
    '早就都批啦。现在才来查看呀。'
  end

  def show_approved
    if @approved.size > 0
      "#{@approved.join(' ')}已经同意了。\n"
    else
      show_waiting
    end
  end

  def show_undecided
    "该#{@states.peek}做决定了。\n 之后会由#{@undecided[1..-1].join(' ')}做决定。"
  end

  def show_error
    '我根本搞不懂你要干什么。'
  end

  def current
    if !@reject_msg.empty?
      show(:reject)
    elsif @done
      show(:succeed)
    else
      show(:all) + show(:approved) + show(:undecided)
    end
  end

  def succeed
    @done = true
    @whose_turn = nil
    notify && '恭喜。全部流程走完了。休息一下吧。'
  end

  def notify
    # notify user
  end
end

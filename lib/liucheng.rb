class Liucheng
  include Enumerable

  attr_reader :user, :msg, :states, :undecided, :approved, :status, :whose_turn, :reject_msg
  attr_accessor :done, :whose_turn, :reject_msg
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
        @status = true
        @whose_turn = nil
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

  def reject(msg='我根本不care')
      @reject_msg << @whose_turn << msg
      @status = :rejected
  end

  def show(msg)
    case msg
    when :all
        "就你这点儿屁事，牵动了#{@states.to_a.join(' ')}这些领导的心。\n"
    when :reject
        who, msg = @reject_msg
        "#{who}说：#{msg}"
    when :succeed
      "早就都批啦。现在才来查看呀。"
    when :approved
      if @approved.size > 0
        "#{@approved.join(' ')}已经同意了。\n"
      else
        "领导都很忙的，还没开始审批呢。"
      end
    when :undecided
      "该#{@states.peek}做决定了。\n 之后会由#{@undecided[1..-1].join(' ')}做决定。"
    else
      "我根本搞不懂你要干什么。"
    end
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

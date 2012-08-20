# Display or hide a jQuery DOM element, depending on a form element value
# Dependences: jQuery ; Underscore.js
#
# Sample:
# -------
# <select name="selector">
#   <option value="0">hide</option>
#   <option value="1">show</option>
# </select>
#
# <div data-display-if="selector" data-has-value="[1]">lorem</div>
#
# <script type="text/javascript">
#   $('[data-display-if]').conditionallyDisplayed()
# </script>

(($) ->
  class ConditionallyDisplayed
    constructor: (@el, @triggerChangeEvent = false) ->
      # The form element this node depends of
      @relyOn = $("[name='#{@el.data 'display-if'}']")
      # Values expected to show the element
      @expectedValues = @el.data 'has-value'

      @bindEvents()
      @updateDisplay()

    bindEvents: ->
      callback = (event) => @updateDisplay()
      @relyOn.change(callback).click(callback)

    updateDisplay: ->
      if _.include(@expectedValues, @valueOfAssociatedNode())
        @el.show()
      else
        @el.hide()
      @el.parent().trigger('change') if @triggerChangeEvent == true

    valueOfAssociatedNode: ->
      if @relyOn.attr('type') == 'radio'
        @relyOn.filter(':checked').val()
      else
        @relyOn.val()


  $.fn.reattachable = ->
    # Save initial position
    parent       = this.parent()
    nextSiblings = this.nextAll()

    this.attach = ->
      if this.is(':hidden')
        next = nextSiblings.filter(':visible').get(0)
        if next then this.insertBefore(next) else this.appendTo(parent)
    this.detach = ->
      $.fn.detach.call(this)


  $.fn.conditionallyDisplayed = ->
    this.each ->
      el = $(this)
      triggerChangeEvent = false

      if this.tagName == 'OPTION'
        triggerChangeEvent = true
        el.reattachable()
        el.hide = el.detach
        el.show = el.attach

      new ConditionallyDisplayed el, triggerChangeEvent

)(jQuery)

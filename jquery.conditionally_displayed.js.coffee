(($) ->
  class ConditionallyDisplayed
    constructor: (@jQueryNode) ->
      @associatedNode = $("[name='#{@jQueryNode.data 'display-if'}']")
      @expectedValues = @jQueryNode.data 'has-value'
      @bindEvents()
      @updateDisplay()

    bindEvents: ->
      @associatedNode.change (event) => @updateDisplay()

    updateDisplay: ->
      if @display() then @showNode() else @hideNode()

    display: ->
      _.include(@expectedValues, @valueOfAssociatedNode())

    valueOfAssociatedNode: ->
      if @associatedNode.attr('type') == 'radio'
        @associatedNode.filter(':checked').val()
      else
        @associatedNode.val()

    showNode: ->
      @jQueryNode.show('highlight', color: '#AFFFAF', 1000)

    hideNode: ->
      @jQueryNode.hide()

  $.fn.conditionallyDisplayed = ->
    this.each -> new ConditionallyDisplayed $(this)
)(jQuery)

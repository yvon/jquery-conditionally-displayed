(($) ->
  class ConditionallyDisplayed
    # Node is replaced by an invisible content when 'hidden'
    # This way we support hide/show on <option> elements
    @hiddenNode: $('<div style="display:none"></div>')

    constructor: (@jQueryNode) ->
      @nodeBackup     = @jQueryNode
      @associatedNode = $("[name='#{@jQueryNode.data 'display-if'}']")
      @expectedValues = @jQueryNode.data 'has-value'
      @bindEvents()
      @updateDisplay()

    bindEvents: ->
      @associatedNode.change (event) => @updateDisplay()

    # Show or hide the node depending on another form element
    updateDisplay: ->
      if @display() then @showNode() else @hideNode()

    # Should we display the node ? => returns true or false
    display: ->
      _.include(@expectedValues, @valueOfAssociatedNode())

    # Get the value of the form element we depend of
    valueOfAssociatedNode: ->
      if @associatedNode.attr('type') == 'radio'
        @associatedNode.filter(':checked').val()
      else
        @associatedNode.val()

    # Show the node
    showNode: ->
      @jQueryNode = @nodeBackup.replaceAll(@jQueryNode)

    # Hide the node
    hideNode: ->
      @jQueryNode = @hiddenNode().replaceAll(@jQueryNode)

    # Build node of substitution when content is hidden
    hiddenNode: ->
      @constructor.hiddenNode.clone()

  $.fn.conditionallyDisplayed = ->
    this.each -> new ConditionallyDisplayed $(this)
)(jQuery)

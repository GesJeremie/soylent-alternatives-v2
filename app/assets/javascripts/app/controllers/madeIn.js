/**
 * MadeIn
 */

(function() {
    'use strict';

    var Controller = new Class({

        extends: Stimulus.Controller,

        static: {
            targets: []
        },

        emitCreated: function () {
            $(document).trigger('madeIn:created', {
                value: $(this.element).val()
            });
        },

        emitUpdated: function () {
            $(document).trigger('madeIn:updated', {
                value: $(this.element).val()
            });
        },

        initialize: function () {
            this.setupSelect();
            this.emitCreated();
            this.events();
        },

        setupSelect: function () {
            if ($(window).width() < 760) { return; }

            $(this.element).select2({
                minimumResultsForSearch: -1
            });
        },

        events: function () {
            $(this.element).on('change', this.onChangeSort.bind(this));
        },

        onChangeSort: function () {
            this.emitUpdated();
        }
    });

    window.app.stimulus.register('madeIn', Controller);
}());

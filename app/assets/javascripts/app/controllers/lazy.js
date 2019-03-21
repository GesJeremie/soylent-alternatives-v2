(function() {
    'use strict';

    window.app.stimulus.register('lazy', new Class({

        extends: Stimulus.Controller,

        /**
         * Boot
         */

        initialize: function () {
            $(this.element).Lazy({
                attribute: 'data-lazy-src'
            });
        }
    }));
}());

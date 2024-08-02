function _make_figures(plot_dir, plot_format)
    ids_array = winsid();
  
    for i=1:length(ids_array)
        id = ids_array(i);
        outfile = sprintf('%s/__ipy_sci_fig_%03d', plot_dir, i);

        // Note: this method of testing visibility of all axes
        // is not general but since I don't master Scilab this
        // was the way to go. A user could for instance disable
        // axes visibilities and then this function would not
        // behave as expected. For most cases this should work.

        fig = gca();
        if and(fig.axes_visible(1) ~= ["off", "off", "off"]) then
            if plot_format == 'jpg' then
                xs2jpg(id, outfile + '.jpg');
            elseif plot_format == 'jpeg' then
                xs2jpg(id, outfile + '.jpeg');
            elseif plot_format == 'png' then
                xs2png(id, outfile);
            else
                xs2svg(id, outfile);
            end

            close(get_figure_handle(id));
        end
    end
    delete("all");
endfunction
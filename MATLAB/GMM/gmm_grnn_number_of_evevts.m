function [ia,ic] = gmm_grnn_number_of_evevts(ip,varargin)
#function [ia,ic] = gmm_grnn_number_of_evevts(ip,varargin)
# Gest events from the record data ip

    data = sortrows(ip.data,ip.event_key);
    [~,ia,ic] = unique(data,ip.event_key);
end
function session = add_pipeline(session,str_pipeline)

% Append filtering process

if not(isfield(session.info,'pipeline'))
    session.info.pipeline{1}=str_pipeline;
else
    if isempty(session.info.pipeline)
        session.info.pipeline{1}=str_pipeline;
    else
        session.info.pipeline = {session.info.pipeline str_pipeline};
    end
end


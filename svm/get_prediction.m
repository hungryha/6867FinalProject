% obs: row vector
function[output, predictions] = get_prediction(models, obs)
predictions = zeros(10,1);
for i=1:10

  for j=i+1:10
    model = models{i,j};
    prediction = svmclassify(model, obs); 
    predictions(prediction) = predictions(prediction) + 1;
  end
end 
[max_val, argmax] = max(predictions);
output = argmax;
end

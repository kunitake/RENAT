#!/bin/sh

if [[ ! -f chibalab.robot ]] && [[ ! -f lab.robot ]]; then
  echo "should be applied in a project folder which has chibalab.robot or lab.robot"
  exit 1
else
  for i in $(find . -type f -name "chibalab.robot"); do
    LAB=$(echo $i | sed 's/chiba//')
    mv $i $F
  done
  echo "moved chibalab.robot to lab.robot"

  FILE=$RENAT_PATH/tools/template/project/lab.robot
  if [[ -f ./lab.robot ]]; then
        diff $FILE lab.robot
        if [[ $? != 0 ]]; then
            cp -f $FILE .
            echo "updated lab.robot"
            echo "---"
        fi
  fi

  FILE=$RENAT_PATH/tools/template/project/run.sh
  diff $FILE run.sh
  if [[ $? != 0 ]]; then 
    cp -f $RENAT_PATH/tools/template/project/run.sh .
    echo "updated project run.sh"
    echo "---"
  fi

  RUN_FILE=$RENAT_PATH/tools/template/item/run.sh
  for entry in $(find . -type d -name config); do
    if [[ -f $entry/../run.sh ]]; then
       diff $RUN_FILE  $entry/../run.sh
       cp -f $RUN_FILE $entry/../run.sh
       echo "updated $entry/../run.sh"
    fi
    ln -sf ../lab.robot $entry/../lab.robot
    echo "updated lab.robot"
    echo "---"
  done

  find . -name "main.robot" -exec sed -i 's/chibalab.robot/lab.robot/' {} \;
  find . -name "main.robot" -exec sed -i 's/\.\.\/lab\.robot/lab\.robot/' {} \;
  echo "updated main.robot"
fi

  

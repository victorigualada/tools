#!/bin/sh
search_dir=$1
repository_content="import { EntityRepository, Repository } from 'typeorm';\\nimport { \${camelEntity} } from '../entities/\${entity}.entity';\\n
import { Injectable } from '@nestjs/common';\\n\\n@Injectable()\\n@EntityRepository( \${camelEntity} )\\n
export class \${camelEntity}Repository extends Repository< \${camelEntity} > { }"


setAliasForFindCommand() {
    find_command='C:\devonfw\software\cmder\vendor\git-for-windows\usr\bin\find.exe'
}

findEntities() {
    $find_command $search_dir -iname "*.entity.ts" -type f | while read -r entityFile
    do
        createControllerServiceRepository $entityFile
    done
}

createControllerServiceRepository() {
    entityDomain=${entityFile%/*/*}
    entity="$(basename $entityFile .entity.ts)"
    echo "Creating Service-Controller-Repository for $entity"
    cd $entityDomain

    createController $enitt
    createService $entity
    writeRepository $entity $entityDomain
}

createService() {
    nest g service "services/${entity}" --flat --no-spec > /dev/null
}

createController() {
    nest g controller "controllers/${entity}" --flat --no-spec > /dev/null
}

writeRepository() {
    repository_file="${entityDomain}/repositories/${entity}.repository.ts"
    touch "${repository_file}"
    converSnakeCaseToCamelCase $entity
    echo -e $repository_content | sed -e "s/\${camelEntity}/"$camelEntity"/g" -e "s/\${entity}/"$entity"/g" > $repository_file
}

converSnakeCaseToCamelCase() {
    snakeCase=$(echo $entity | sed 's/\-/_/g')
    camelEntity=$(echo ${snakeCase} | sed -re 's/(_([a-zA-Z]))+([a-zA-Z]+)+/\U\2\L\3/g;s/(^[a-z])/\U\1/')
}

run() {
    setAliasForFindCommand
    findEntities
}

run

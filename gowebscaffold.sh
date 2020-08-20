#!/bin/bash
ACTION_NAME=$1
PROJECT_NAME=$2
#CURRENT_PWD=`pwd`

function generate_controllers_index() {
    cat > "$1"<<EOF
package controllers

import (
	"github.com/gin-gonic/gin"
	"net/http"
)

func HomeIndex(ctx *gin.Context) {
	ctx.JSON(http.StatusOK, map[string]interface{}{"data":[]string{"It", "works."}, "err": nil})
}
EOF
}

function generate_routers_router() {
    cat > "$1"<<EOF
package routers

import (
	"github.com/gin-gonic/gin"
)
func Init(engine *gin.Engine) {
  
    indexRouter := engine.Group("/")
    {
        indexRouter.GET("/index", controllers.HomeIndex)
    }
}
EOF
}

function generate_main() {
    cat > "$1" <<EOF
package main

import (
	"github.com/gin-gonic/gin"
	"log"
)

func init() {
	// do
}

func main() {
    router := gin.Default()
    // 静态文件路由设置
    router.Static("/statics/", "./statics")
    router.Static("/templates/", "./templates")

    // 动态注册服务路由
    routers.Init(router)

    // 服务启动
    err := router.Run(":8080")
    if err != nil {
	log.Fatal(err)
    }
}
EOF
}

function generate_templates_index() {
    cat > "$1" <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>

</body>
</html>
EOF
}

function generate() {
    # shellcheck disable=SC2046
    if [ ! -d "$1/controllers" ]; then mkdir -p "$1"/controllers ; fi
    if [ ! -f "$1/controllers/index.go" ]; then generate_controllers_index "$1/controllers/index.go"; fi

    if [ ! -d "$1/conf" ]; then mkdir -p "$1"/conf ; fi
    if [ ! -d "$1/models" ]; then mkdir -p "$1"/models ; fi
    if [ ! -d "$1/scripts" ]; then mkdir -p "$1"/scripts ; fi
    if [ ! -d "$1/library" ]; then mkdir -p "$1"/library ; fi
    if [ ! -d "$1/routers" ]; then mkdir -p "$1"/routers ; fi
    if [ ! -f "$1/routers/router.go" ]; then generate_routers_router "$1"/routers/router.go ; fi

    if [ ! -d "$1/statics" ]; then mkdir -p "$1"/statics ; fi
    if [ ! -d "$1/statics/css" ]; then mkdir -p "$1"/statics/css ; fi
    if [ ! -d "$1/statics/js" ]; then mkdir -p "$1"/statics/js ; fi
    if [ ! -d "$1/statics/img" ]; then mkdir -p "$1"/statics/img ; fi

    if [ ! -d "$1/templates" ]; then mkdir -p "$1"/templates ; fi
    if [ ! -d "$1/templates/index.html" ]; then generate_templates_index "$1"/templates/index.html ; fi

    if [ ! -f "$1/main.go" ]; then generate_main "$1"/main.go; fi
}


if [ $ACTION_NAME == "generate" ]; then
    generate $PROJECT_NAME
fi



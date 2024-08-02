# -*- coding: utf-8 -*-
import casadi as cs
import opengen as og

p = cs.SX.sym("p")
x = cs.SX.sym("x", 2)

f = (p * x[1] - x[0] ** 2) ** 2
g =  x[0] + x[1] - 1


set_c = og.constraints.Zero()

rect = og.constraints.Rectangle(xmin=[0, 0], 
                                xmax=[1, 1])

problem = og.builder.Problem(x, p, f)          \
    .with_aug_lagrangian_constraints(g, set_c) \
    .with_constraints(rect)

meta = og.config.OptimizerMeta()         \
    .with_version("0.1.0")               \
    .with_authors(["W. Dal'Maz Silva"])  \
    .with_licence("MIT")                 \
    .with_optimizer_name("dummy")

# This is the default
tcp_config = og.config.TcpServerConfiguration('127.0.0.1', 8333)

build_config = og.config.BuildConfiguration()  \
    .with_build_directory("python_build")      \
    .with_build_mode("debug")                  \
    .with_tcp_interface_config(tcp_config)

solver_config = og.config.SolverConfiguration()   \
            .with_lbfgs_memory(100)               \
            .with_tolerance(1.0e-08)              \
            .with_max_inner_iterations(5000)

builder = og.builder.OpEnOptimizerBuilder(
    problem,
    metadata=meta,
    build_configuration=build_config,
    solver_configuration=solver_config)

builder.build()


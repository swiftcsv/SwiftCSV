FROM ibmcom/swift-ubuntu:latest

WORKDIR /SwiftCSV
COPY ./Package.swift /SwiftCSV/Package.swift
COPY ./Sources /SwiftCSV/Sources
COPY ./Tests /SwiftCSV/Tests

RUN swift test

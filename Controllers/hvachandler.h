#ifndef HVACHANDLER_H
#define HVACHANDLER_H

#include <QObject>

class HVACHandler : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int targetTemparature READ targetTemparature WRITE setTargetTemparature NOTIFY targetTemparatureChanged)
public:
    explicit HVACHandler();

    int targetTemparature() const;
    void setTargetTemparature(int newTargetTemparature);
    Q_INVOKABLE void incrementTargetTemparature(const int &val);

signals:
    void targetTemparatureChanged();

private:

    int m_targetTemparature;
};

#endif // HVACHANDLER_H
